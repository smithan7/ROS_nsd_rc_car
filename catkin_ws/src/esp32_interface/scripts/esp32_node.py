#!/usr/bin/env python


import rospy
from esp32_interface.msg import PWM_Measure
from esp32_interface.msg import PWM_Cmd
from esp32_interface.msg import Driveshaft_Encoder
from std_msgs.msg import String

import serial
import serial.tools.list_ports


class ESP32_Interface:
    steer_cmd = 0.0
    speed_cmd = 0.0
    pwm_ramp_rate = 10.0 # currently not used - I am not confident this is actually a good idea/useful even for sys id
    last_driveshaft_time = 0.0

    def __init__(self):

        self.pwm_ser = serial.Serial()
        attempts = 0
        pwm_ser_open = False

        self.list_serial_ports()
        self.esp32_port = self.find_esp32()
        # print("esp32_port: ", self.esp32_port)
        while not pwm_ser_open and attempts < 50:
            if not pwm_ser_open:
                try:
                    self.pwm_ser = serial.Serial(self.esp32_port, 115200, timeout=0.1)
                    pwm_ser_open = True
                except:
                    print("ESP32_Interface::Failed to open pwm serial port: ", attempts)
                    attempts += 1
                    
        self.pwm_ser.flush()

        self.steve_cmd_pub = rospy.Publisher('steve_measured', PWM_Measure, queue_size=10)
        self.xavier_cmd_pub = rospy.Publisher('xavier_measured', PWM_Measure, queue_size=10)
        self.driveshaft_encoder_pub = rospy.Publisher('driveshaft_rotation_speed', Driveshaft_Encoder, queue_size=10)
        self.cmds_sub = rospy.Subscriber("ui_commands", PWM_Cmd, self.cmds_sub_callback)
        self.param_sub = rospy.Subscriber("esp32_params", String, self.param_sub_callback)

        rospy.Timer(rospy.Duration(1.0/100.0), self.read_serial_buffer)
        rospy.Timer(rospy.Duration(1.0/20.0), self.write_serial_comands)

    def param_sub_callback(self, msg):
        # this reads in the string from the UI updates params
        p_msg = str(msg.data).splot(',')
        if p_msg[0] == 'ramp rate' and float(p_msg[1]) > 0.0 and float(p_msg[1]) <= 100.0:
            # update ramp rate
            self.pwm_ramp_rate = float(p_msg[1])
        else:
            # for some reason it did not parse
            print("esp32_node::param_sub_callback::received bad msg: ", msg.data)

    def cmds_sub_callback(self, msg):
        # rospy.loginfo(rospy.get_caller_id() + "I heard %s", msg)
        self.speed_cmd= msg.speed
        self.steer_cmd = msg.steer

    def read_serial_buffer(self, event=None):
        # self.pwm_ser.flushInput()
        while self.pwm_ser.in_waiting > 0:
            pwm_bytes = self.pwm_ser.readline()
            # print("pwm_bytes: ", pwm_bytes)
            try:
                decoded_pwm_strings = str(pwm_bytes[0:len(pwm_bytes)-2].decode("utf-8")).split(',')
                # print("decoded pwm string[", len(decoded_pwm_strings), "]: ", decoded_pwm_strings)
                if decoded_pwm_strings[0] == 'C':
                    # This is a measured PWM report
                    steve_lag_time = int(decoded_pwm_strings[1]) # time since last status message
                    xavier_lag_time = int(decoded_pwm_strings[2]) # time since last xavier message
                    steve_status_flag = int(decoded_pwm_strings[3])
                    steve_cntrl_command = int(decoded_pwm_strings[4])
                    steve_speed_command = int(decoded_pwm_strings[5])
                    steve_steer_command = int(decoded_pwm_strings[6])
                    xavier_status_flag = int(decoded_pwm_strings[7])
                    xavier_speed_command = int(decoded_pwm_strings[8])
                    xavier_steer_command = int(decoded_pwm_strings[9])
                    driveshaft_time = int(decoded_pwm_strings[10])
                    driveshaft_rpm = 60000000. / float(decoded_pwm_strings[11])
                    
                    # checksum = (z_command + z_steer + z_speed) % 1000
                    # print("checksum: ", checksum)
                    # if z_checksum == checksum:

                    msg = PWM_Measure()
                    msg.time = steve_lag_time
                    msg.status = steve_status_flag
                    msg.control = steve_cntrl_command
                    msg.steer = steve_steer_command
                    msg.speed = steve_speed_command
                    # print("steve_msg: ", msg)
                    self.steve_cmd_pub.publish(msg)

                    msg = PWM_Measure()
                    msg.time = xavier_lag_time
                    msg.status = xavier_status_flag
                    msg.control = steve_cntrl_command
                    msg.steer = xavier_steer_command
                    msg.speed = xavier_speed_command
                    self.xavier_cmd_pub.publish(msg)

                    if driveshaft_time > self.last_driveshaft_time:
                        msg = Driveshaft_Encoder()
                        msg.rpm = driveshaft_rpm
                        self.driveshaft_encoder_pub.publish(msg)
                    else:
                        msg = Driveshaft_Encoder()
                        msg.rpm = 0.0
                        self.driveshaft_encoder_pub.publish(msg)
                    self.last_driveshaft_time = driveshaft_time

                else:
                    print("ESP32 Node: failed to parse serial message")
                    print("decoded pwm string[", len(decoded_pwm_strings), "]: ", decoded_pwm_strings)
            except:
                print("ESP32_Iterface::Error decoding and splitting pwm bytes")
        
    def write_serial_comands(self, event=None):
        try:
                cmd_str = ('C,' + str(self.steer_cmd) + ',' + str(self.speed_cmd) + ',' + str((self.steer_cmd + self.speed_cmd) % 1000) + '\r\n').encode("utf-8")
                self.pwm_ser.write(cmd_str)
        except:
            print("ESP32_ Interface::Error writing to Arduino")

    def find_esp32(self, port=None):
        """Get the name of the port that is connected to Arduino."""
        if port is None:
            ports = serial.tools.list_ports.comports()
            for p in ports:
                # print("p.manufacturer: ", p.manufacturer, " and ", p)
                if p.manufacturer is not None and "Silicon Labs" in p.manufacturer:
                    port = p.device
        return port

    def list_serial_ports(self):
        ports = serial.tools.list_ports.comports()

        for port, desc, hwid in sorted(ports):
                print("{}: {} [{}]".format(port, desc, hwid))

if __name__ == '__main__':
    rospy.init_node("ESP32_Interface")
    # Create an instance of Temperature sensor
    ei = ESP32_Interface()
    # Create a ROS Timer for reading data
    rospy.spin()
