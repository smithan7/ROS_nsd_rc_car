#!/usr/bin/env python2


import rospy
from esp32_interface.msg import PWM_Measure
from esp32_interface.msg import PWM_Cmd

import serial
import serial.tools.list_ports


class ESP32_Interface:
    steer_cmd = 0.0
    speed_cmd = 0.0

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

        self.z_cmd_pub = rospy.Publisher('measured_commands', PWM_Measure, queue_size=10)
        self.cmd_pub = rospy.Publisher('published_commands', PWM_Cmd, queue_size=10)
        self.cmds_sub = rospy.Subscriber("input_commands", PWM_Cmd, self.cmds_sub_callback)


        rospy.Timer(rospy.Duration(1.0/100.0), self.read_serial_buffer)
        rospy.Timer(rospy.Duration(1.0/20.0), self.write_serial_comands)

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
                # print("decoded pwm string: ", decoded_pwm_strings)
                if decoded_pwm_strings[0] == 'Z':
                    # This is a measured PWM report
                    z_status = int(decoded_pwm_strings[1])
                    z_time = int(decoded_pwm_strings[2])
                    z_command = int(decoded_pwm_strings[3])
                    z_steer = int(decoded_pwm_strings[4])
                    z_speed = int(decoded_pwm_strings[5])
                    z_checksum = int(decoded_pwm_strings[6])
                    checksum = (z_command + z_steer + z_speed) % 1000
                    # print("checksum: ", checksum)
                    if z_checksum == checksum:
                        msg = PWM_Measure()
                        msg.time = z_time
                        msg.status = z_status
                        msg.control = z_command
                        msg.steer = z_steer
                        msg.speed = z_speed
                        self.z_cmd_pub.publish(msg)

                elif decoded_pwm_strings[0] == 'C':
                    # This is a measured PWM report
                    # print("cmd message")
                    z_time = int(decoded_pwm_strings[1])
                    z_steer = int(decoded_pwm_strings[2])
                    z_speed = int(decoded_pwm_strings[3])
                    z_checksum = int(decoded_pwm_strings[4])
                    checksum = (z_steer + z_speed) % 1000
                    if z_checksum == checksum:
                        msg = PWM_Cmd()
                        msg.time = z_time
                        msg.steer = z_steer
                        msg.speed = z_speed
                        self.cmd_pub.publish(msg)
                        
                elif decoded_pwm_strings[0] == 'E':
                    print("ESP32_Interface::Error message recieved - Arduino has timed out waiting for a command")
            except:
                print("ESP32_Iterface::Error decoding and splitting pwm bytes")
        
    def write_serial_comands(self, event=None):
        try:
                cmd_str = ('C,' + str(self.steer_cmd) + ',' + str(self.speed_cmd) + ',' + str((self.steer_cmd + self.speed_cmd) % 1000) + '\r\n').encode("utf-8")
                self.pwm_ser.write(cmd_str)
        except:
            print("ESP32_ Interface::Error writing to Arduino")



if __name__ == '__main__':
    rospy.init_node("ESP32_Interface")
    # Create an instance of Temperature sensor
    ei = ESP32_Interface()
    # Create a ROS Timer for reading data
    rospy.spin()
