#!/usr/bin/env python3

import rospy
import sys
import csv
import time
import struct
import collections
import threading
import sys
import csv
import time
import serial
import struct
import collections
import threading
import numpy as np
import socket
import math

from nav_msgs.msg import Odometry
from esp32_interface.msg import PWM_Measure, PWM_Cmd, Driveshaft_Encoder



PACKET_DEF = {'i1': [116, bytes([0x55, 0x55, 0x69, 0x31])]} # {'<packet name>': [<payload length>, <packet header>]}

class UserInterface:
    def __init__(self):
        
        ## Running on the car IP - 192.168.1.11
        self.SEND_UDP_IP = "192.168.1.11"
        self.RECV_UDP_IP = "192.168.1.137"
        # # Running a test over wifi
        # self.SEND_UDP_IP = "192.168.1.29"
        self.SEND_UDP_PORT = 5005

        # self.RECV_UDP_IP = "192.168.1.35"
        self.RECV_UDP_PORT = 5006
        self.recv_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.recv_sock.bind((self.RECV_UDP_IP, self.RECV_UDP_PORT))
        self.recv_sock.settimeout(0.01)

        # this sends out the commands to the ESP32 from the user
        self.ui_cmd_pub = rospy.Publisher('ui_commands', PWM_Cmd, queue_size=10)

        self.ins_string_sub = rospy.Subscriber('odom', Odometry, self.log_ins, queue_size=10)
        self.ins_message = Odometry()
        # this reads steves commands from the ESP32
        self.steve_cmd_sub = rospy.Subscriber('steve_measured', PWM_Measure, self.log_steve_cmd, queue_size=10)
        self.steve_pwm_msg = PWM_Measure()
        self.xavier_cmd_sub = rospy.Subscriber('xavier_measured', PWM_Measure, self.log_xavier_cmd, queue_size=10)
        self.xavier_pwm_msg = PWM_Measure()
        self.driveshaft_encoder_sub = rospy.Subscriber('driveshaft_rotation_speed', Driveshaft_Encoder, self.log_driveshaft_rotation_speed, queue_size=10)
        self.xavier_pwm_msg = PWM_Measure()
        self.new_nav = False
        self.new_steve = False
        self.new_xavier = False
        self.new_driveshaft_rotation_speed = False

        self.spds = []
        self.spd_durs = []
        self.strs = []
        self.str_durs = []

        rospy.Timer(rospy.Duration(1.0/15.0), self.transmit_data)
        rospy.Timer(rospy.Duration(1.0/20.0), self.recv_data)
        rospy.Timer(rospy.Duration(1.0/20.0), self.publish_user_pwm_commands)        
        


    def log_ins(self, msg):
        self.ins_message = msg
        self.new_nav = True

    def log_driveshaft_rotation_speed(self, msg):
        self.driveshaft_rotation_speed = msg.rpm
        self.new_driveshaft_rotation_speed = True

    def log_steve_cmd(self, msg):
        self.steve_pwm_msg.time = msg.time
        self.steve_pwm_msg.status = msg.status
        self.steve_pwm_msg.control = msg.control
        self.steve_pwm_msg.steer = msg.steer
        self.steve_pwm_msg.speed = msg.speed
        self.new_steve = True

    def log_xavier_cmd(self, msg):
        self.xavier_pwm_msg.time = msg.time
        self.xavier_pwm_msg.status = msg.status
        self.xavier_pwm_msg.control = msg.control
        self.xavier_pwm_msg.steer = msg.steer
        self.xavier_pwm_msg.speed = msg.speed
        self.new_xavier = True


    def euler_from_quaternion(self, x, y, z, w):
            """
            Convert a quaternion into euler angles (roll, pitch, yaw)
            roll is rotation around x in radians (counterclockwise)
            pitch is rotation around y in radians (counterclockwise)
            yaw is rotation around z in radians (counterclockwise)
            """
            t0 = +2.0 * (w * x + y * z)
            t1 = +1.0 - 2.0 * (x * x + y * y)
            roll_x = math.atan2(t0, t1)
        
            t2 = +2.0 * (w * y - z * x)
            t2 = +1.0 if t2 > +1.0 else t2
            t2 = -1.0 if t2 < -1.0 else t2
            pitch_y = math.asin(t2)
        
            t3 = +2.0 * (w * z + x * y)
            t4 = +1.0 - 2.0 * (y * y + z * z)
            yaw_z = math.atan2(t3, t4)
        
            return roll_x, pitch_y, yaw_z # in radians
    
    def yaw_from_quaternion(self, x, y, z, w):
        """
        Convert a quaternion into euler angles (roll, pitch, yaw)
        roll is rotation around x in radians (counterclockwise)
        pitch is rotation around y in radians (counterclockwise)
        yaw is rotation around z in radians (counterclockwise)
        """
        t3 = +2.0 * (w * z + x * y)
        t4 = +1.0 - 2.0 * (y * y + z * z)
        return math.atan2(t3, t4)
    
    def recv_data(self, event=None):
        # This reads input commands from the user and publishes them out over the socket
        try:
            msg, addr = self.recv_sock.recvfrom(1024)
            msg = msg.decode().split(',')
            # print("ui_node::recv_data::msg: ", msg)
            # print("addr: ", addr)
            msg_time = time.time()
            if msg[0] == 'sp':
                self.spds = []
                self.spd_durs = []
                s_time = msg_time + 0.1
                try:
                    for i in range(1,len(msg),2):
                        if float(msg[i])>0 and float(msg[i])<=100 and float(msg[i+1])>=1200 and float(msg[i+1])<=1800:
                            s_time += float(msg[i])
                            self.spd_durs.append(s_time)
                            self.spds.append(int(msg[i+1]))
                except:
                    print("UI_Node::recv_data::speed message was bad: ", msg)
            elif msg[0] == 'st':
                self.strs = []
                self.str_durs = []
                s_time = msg_time + 0.1
                try:
                    for i in range(1,len(msg),2):
                        if float(msg[i])>0 and float(msg[i])<=100 and float(msg[i+1])>=1200 and float(msg[i+1])<=1800:
                            s_time += float(msg[i])
                            self.str_durs.append(s_time)
                            self.strs.append(int(msg[i+1]))
                except:
                    print("UI_Node::recv_data::steer message was bad: ", msg)
        except:
            pass

    def publish_user_pwm_commands(self, event=None):
        out_cmd = PWM_Cmd()
        out_cmd.header.stamp = rospy.Time.now()
        out_cmd.header.frame_id = 'PWM'
        # out_cmd.time = not sure what goes here...
        good_sp_set = False
        # print("ui_node::publish_ui_pwm_commands::speed times: ", str(time.time()), " - sp = ", self.spd_durs)
        if len(self.spd_durs) > 0 and len(self.spd_durs) == len(self.spds):
            # there are speed commands to publish to the ESP32
            # print(str(time.time()), " - in sp: ", self.spd_durs)
            while len(self.spd_durs) > 0:
                if time.time() < self.spd_durs[0]:
                    # print("less than spd time")
                    out_cmd.speed = self.spds[0]
                    good_sp_set = True
                    break
                else:
                    # print("not less than spd time")
                    self.spd_durs.pop(0)
                    self.spds.pop(0)
        if not good_sp_set:
            out_cmd.speed = 1500

        good_st_set = False
        # print("ui_node::publish_ui_pwm_commands::steer times: ", str(time.time()), " - st = ", self.str_durs)
        if len(self.str_durs) > 0 and len(self.str_durs) == len(self.strs):
            # there are steer commands to publish to the ESP32
            # print(str(time.time()), " - in st: ", self.str_durs)
            while len(self.str_durs) > 0:
                if time.time() < self.str_durs[0]:
                    out_cmd.steer = self.strs[0]
                    good_st_set = True
                    break
                else:
                    self.str_durs.pop(0)
                    self.strs.pop(0)
        if not good_st_set:
            out_cmd.steer = 1500

        # print("out_cmd:\n", out_cmd)
        self.ui_cmd_pub.publish(out_cmd)

    def transmit_data(self, event=None):
        msg = 'c,'
        msg += str(time.time()) + ','
        if self.new_steve:
            msg += str(self.steve_pwm_msg.time / float(10**3)) + ','
            msg += str(self.steve_pwm_msg.status) + ','
            msg += str(self.steve_pwm_msg.control) + ','
            msg += str(self.steve_pwm_msg.steer) + ','
            msg += str(self.steve_pwm_msg.speed) + ','

            self.new_steve = False
        else:
            msg += '-1,-1,-1,-1,-1,'
        if self.new_xavier:
            msg += str(self.xavier_pwm_msg.time) + ','
            msg += str(self.xavier_pwm_msg.status) + ','
            msg += str(self.xavier_pwm_msg.steer) + ','
            msg += str(self.xavier_pwm_msg.speed) + ','

            self.new_xavier = False
        else:
            msg += '-1,-1,-1,-1,'

        if self.new_driveshaft_rotation_speed:
            msg += str(self.driveshaft_rotation_speed) + ','
            self.new_driveshaft_rotation_speed = False
        else:
            msg += '-1,'
        
        print("UI_Node::cmd msg: ", msg)
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            sock.sendto(msg.encode(), (self.SEND_UDP_IP, self.SEND_UDP_PORT))
        except:
            print("UI_Node::transmit_data: failed to send over socket")

        msg = 'n,'
        msg += str(time.time()) + ','
        if self.new_nav:
            msg += str(self.ins_message.pose.pose.position.x) + ','
            msg += str(self.ins_message.pose.pose.position.y) + ','


            yaw = self.yaw_from_quaternion(self.ins_message.pose.pose.orientation.x,
                                        self.ins_message.pose.pose.orientation.y,
                                        self.ins_message.pose.pose.orientation.z,
                                        self.ins_message.pose.pose.orientation.w)

            speed = np.sqrt(self.ins_message.twist.twist.linear.x**2 + self.ins_message.twist.twist.linear.y**2)

            msg += str(yaw) + ','
            msg += str(speed) + ','
            msg += '0.0,'
            msg += '0.0'
        else:
            msg += '-1,-1,-1,-1,-1,-1,-1'

        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            sock.sendto(msg.encode(), (self.SEND_UDP_IP, self.SEND_UDP_PORT))
        except:
            print("UI_Node::transmit_data: failed to send over socket")

if __name__ == "__main__":
    print("Initializing UI_Node")
    rospy.init_node("UI_Interface")
    openrtk = UserInterface()
    rospy.spin()