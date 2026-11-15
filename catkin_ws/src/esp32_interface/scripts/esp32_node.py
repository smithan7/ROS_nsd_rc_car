#!/usr/bin/env python
"""ROS bridge to the ESP32 autopilot interface (serial protocol v2, see esp32_protocol.py).

Latency design: every ui_commands message is written to the ESP32 the moment it arrives
(tcp_nodelay subscriber, no resend timer), and a dedicated thread blocks on readline() so each
line is stamped as soon as it is read. Nothing re-sends a stale command: if the upstream node
dies, commands stop and the ESP32's own 200 ms timeout puts the car in failsafe.

Publishes
  esp32_status (ESP32_Status, 50 Hz)       full status, stamped on read
  esp32_ack (ESP32_Ack, one per command)   timestamp echo + round-trip time
  steve_measured / xavier_measured (PWM_Measure), driveshaft_rotation_speed (Driveshaft_Encoder)
    - the old topics, kept for ui_node; now stamped
Subscribes
  ui_commands (PWM_Cmd): steer / speed in microseconds; publish at >= 5 Hz (50 Hz intended)
Params
  ~port (default: first Silicon Labs USB-serial device), ~baud (default 460800),
  ~encoder_edges_per_rev (default 2: disc with 2 blocked + 2 open quarter segments)
"""

from __future__ import print_function

import threading

import rospy
import serial
import serial.tools.list_ports

import esp32_protocol as P
from esp32_interface.msg import Driveshaft_Encoder, ESP32_Ack, ESP32_Status, PWM_Cmd, PWM_Measure


def find_esp32():
    for p in serial.tools.list_ports.comports():
        if p.manufacturer is not None and "Silicon Labs" in p.manufacturer:
            return p.device
    return None


class ESP32Interface(object):
    def __init__(self):
        self.port_param = rospy.get_param("~port", "")
        self.baud = int(rospy.get_param("~baud", P.BAUD))
        # driveshaft disc: 4 quarter segments, 2 blocked + 2 open -> 2 rising edges per rev
        self.edges_per_rev = int(rospy.get_param("~encoder_edges_per_rev", 2))
        rospy.loginfo("esp32_node: encoder %d rising edges per driveshaft rev", self.edges_per_rev)
        self.ser = self._open()

        self.lock = threading.Lock()  # serial writes + latency tracker
        self.seq = 0
        self.latency = P.LatencyTracker()
        self.bad_lines = 0
        self.last_mode = None

        self.status_pub = rospy.Publisher("esp32_status", ESP32_Status, queue_size=50)
        self.ack_pub = rospy.Publisher("esp32_ack", ESP32_Ack, queue_size=50)
        self.steve_pub = rospy.Publisher("steve_measured", PWM_Measure, queue_size=10)
        self.xavier_pub = rospy.Publisher("xavier_measured", PWM_Measure, queue_size=10)
        self.driveshaft_pub = rospy.Publisher("driveshaft_rotation_speed", Driveshaft_Encoder, queue_size=10)
        rospy.Subscriber("ui_commands", PWM_Cmd, self.on_command, queue_size=1, tcp_nodelay=True)

        self.reader = threading.Thread(target=self.read_loop, name="esp32_reader")
        self.reader.daemon = True
        self.reader.start()

    def _open(self):
        """Open the port, retrying until it appears (USB re-enumeration can rename it).

        DTR/RTS are held low: on most ESP32 dev boards they drive EN/IO0, so the default
        open toggles them and resets the ESP32 - a node restart must not reboot the car."""
        attempt = 0
        while not rospy.is_shutdown():
            port = self.port_param or find_esp32()
            try:
                if not port:
                    raise serial.SerialException("no Silicon Labs USB-serial device")
                ser = serial.Serial()
                ser.port, ser.baudrate, ser.timeout = port, self.baud, 0.5
                ser.dtr = False
                ser.rts = False
                ser.open()
                rospy.loginfo("esp32_node: %s @ %d baud", port, self.baud)
                return ser
            except (serial.SerialException, OSError) as e:
                attempt += 1
                rospy.logwarn_throttle(2.0, "esp32_node: open failed (%d): %s" % (attempt, e))
                rospy.sleep(0.2)
        return None

    def _reconnect(self, err):
        rospy.logerr("esp32_node: serial lost (%s); reopening - the ESP32 fails safe meanwhile" % err)
        with self.lock:
            try:
                self.ser.close()
            except Exception:
                pass
            self.ser = None
        ser = self._open()
        with self.lock:
            self.ser = ser

    # ---- Jetson -> ESP32 ----------------------------------------------------------------
    def on_command(self, msg):
        try:
            line = P.format_command(self.seq, msg.steer, msg.speed)
        except ValueError as e:
            rospy.logwarn_throttle(1.0, "esp32_node: command not sent: %s" % e)
            return
        with self.lock:
            if self.ser is None:  # reconnecting: drop it, a stale command is worse than none
                return
            try:
                self.latency.sent(self.seq, rospy.get_time())
                self.ser.write(line)
            except (serial.SerialException, OSError) as e:
                rospy.logerr_throttle(1.0, "esp32_node: write failed: %s" % e)
                return
            self.seq = (self.seq + 1) % P.SEQ_MOD

    # ---- ESP32 -> Jetson ----------------------------------------------------------------
    def read_loop(self):
        while not rospy.is_shutdown():
            ser = self.ser
            if ser is None:
                rospy.sleep(0.05)
                continue
            try:
                raw = ser.readline()
            except (serial.SerialException, OSError, TypeError) as e:  # TypeError: port closed under us
                self._reconnect(e)
                continue
            if not raw:
                continue
            stamp = rospy.Time.now()
            d = P.parse_line(raw)
            if d is None:
                self.bad_lines += 1
                rospy.logwarn_throttle(5.0, "esp32_node: %d unparsed lines, last %r" % (self.bad_lines, raw[:80]))
            elif d["kind"] == "A":
                self.publish_ack(d, stamp)
            else:
                self.publish_status(d, stamp)

    def publish_ack(self, d, stamp):
        with self.lock:
            rtt = self.latency.acked(d["seq"], stamp.to_sec())
        m = ESP32_Ack()
        m.header.stamp = stamp
        m.seq, m.esp_rx_us, m.mode = d["seq"], d["rx_us"], d["mode"]
        m.out_speed_us, m.out_steer_us = d["out_speed_us"], d["out_steer_us"]
        m.round_trip_s = float("nan") if rtt is None else rtt
        self.ack_pub.publish(m)

    def publish_status(self, d, stamp):
        rpm = P.driveshaft_rpm(d["now_us"], d["enc_last_edge_us"], d["enc_dt_us"], d["enc_count"],
                               edges_per_rev=self.edges_per_rev)
        m = ESP32_Status()
        m.header.stamp = stamp
        m.esp_now_us = d["now_us"]
        m.armed = bool(d["armed"])
        for k in ("mode", "rc_age_ms", "jetson_age_ms", "rc_ch3_us", "rc_speed_us", "rc_steer_us", "jetson_seq",
                  "jetson_speed_us", "jetson_steer_us", "out_speed_us", "out_steer_us", "enc_count",
                  "enc_last_edge_us", "enc_dt_us", "bad_cmds"):
            setattr(m, k, d[k])
        m.driveshaft_rpm = rpm
        self.status_pub.publish(m)

        if d["mode"] != self.last_mode:
            log = rospy.loginfo if d["mode"] >= 0 else rospy.logwarn
            log("esp32_node: mode %s", P.MODE_NAMES.get(d["mode"], d["mode"]))
            self.last_mode = d["mode"]

        # legacy topics (ui_node)
        steve = PWM_Measure()
        steve.header.stamp = stamp
        steve.time, steve.status, steve.control = d["rc_age_ms"], d["mode"], d["rc_ch3_us"]
        steve.steer, steve.speed = d["rc_steer_us"], d["rc_speed_us"]
        self.steve_pub.publish(steve)
        xavier = PWM_Measure()
        xavier.header.stamp = stamp
        xavier.time, xavier.status, xavier.control = d["jetson_age_ms"], d["mode"], d["rc_ch3_us"]
        xavier.steer, xavier.speed = d["jetson_steer_us"], d["jetson_speed_us"]
        self.xavier_pub.publish(xavier)
        enc = Driveshaft_Encoder()
        enc.header.stamp = stamp
        enc.rpm = rpm
        self.driveshaft_pub.publish(enc)


if __name__ == "__main__":
    rospy.init_node("ESP32_Interface")
    ESP32Interface()
    rospy.spin()
