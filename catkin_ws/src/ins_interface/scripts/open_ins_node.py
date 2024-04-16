#!/usr/bin/env python3

import rospy

import time
import struct
import collections
import threading
import time
import serial
import struct
import collections
import threading
import numpy as np

import serial.tools.list_ports

from std_msgs.msg import String
from nav_msgs.msg import Odometry
from sensor_msgs.msg import NavSatFix, Imu


imu_fmt = '<HIffffff'
pva_fmt = fmt = '<HIBBdddddddddfffffffff'


class OpenRTK:
    def __init__(self, port, baud=460800):
        self.port = port
        self.baud = baud
        self.ser = serial.Serial(self.port, self.baud, timeout=0.5)
        self.myqueue = collections.deque(maxlen=10000)

        self.ins_string_pub = rospy.Publisher('INS_String', String, queue_size=10)
        self.ins_navsat_pub = rospy.Publisher('navsat', NavSatFix, queue_size=10)
        self.ins_imu_pub = rospy.Publisher('imu', Imu, queue_size=10)
        self.ins_odom_pub = rospy.Publisher('odom', Odometry, queue_size=10)
        self.ins_msg_cntr = 0
        self.imu_msg_cntr = 0

        self.parse_rtk_data()

    def parse_data(self):
        '''
        Parse the packet data in queue and publish it out to ROS
        '''
        while True:
            if len(self.myqueue) != 0:
                packet_data = self.myqueue.popleft()
                crc = packet_data[-2:]
                cal_crc = bytes(self.calc_crc(packet_data[2: -2]))
                if cal_crc != crc:
                    print('CRC ERROR!')
                else:
                    payload = packet_data[5:-2]
                    latest = self.il_parser(payload)
             

    def parse_rtk_data(self):
        # port = 'COM11' # edit user's port name here
        # ser = serial.Serial(port, 460800, timeout=0.5)
        data_list = []
        
        data_list.append(self.ser.read(3))    
        while True:
            data_list.append(self.ser.read(1))
            
            while len(data_list) > 4:
                data_list.pop(0)

            if data_list[0] == b'U' and data_list[1] == b'U' and data_list[3] == b'1':
                # found a header message
                if data_list[2] == b'i': 
                    # found the PVA msg
                    pva_payload = self.ser.read(119) # tested and s1 starts right after this
                    pva_payload = pva_payload[1:-2]
                    # parse into format
                    data = struct.unpack(pva_fmt, pva_payload)
                    
                    # break into the right peices                
                    # gps_week = data[0]
                    # gps_millisecs = data[1] / 1000
                    # ins_status = data[2]
                    # ins_position_type = data[3]
                    # latitude = data[4]
                    # longitude = data[5]
                    # height = data[6]
                    # north_velocity = data[7]
                    # east_velocity = data[8]
                    # up_velocity = data[9]
                    # roll = data[10]
                    # pitch = data[11]
                    # heading = data[12]
                    # latitude_std = data[13]
                    # longitude_std = data[14]
                    # height_std = data[15]
                    # north_velocity_std = data[16]
                    # east_velocity_std = data[17]
                    # up_velocity_std = data[18]
                    # roll_std = data[19]
                    # pitch_std = data[20]
                    # heading_std = data[21]
                    
                    # print("pva: ", gps_week, ", ", gps_millisecs, ", ", ins_status, ", ", ins_position_type, ", ", latitude, ", ", longitude, ", ", height, ", ", north_velocity, ", ", east_velocity, ", ", \
                    #     up_velocity, ", ", roll, ", ", pitch, ", ", heading, ", ", latitude_std, ", ", longitude_std, ", ", height_std, ", ", north_velocity_std, ", ", east_velocity_std, ", ", \
                    #     up_velocity_std, ", ", roll_std, ", ", pitch_std, ", ", heading_std)
                    
                    # data_str = ' '.join([str(elem)+',' for elem in data]) + '\n'
                    # with open('C:/Users/sgtas/Desktop/autonomous_car/pva.csv','a') as fd:
                    #     fd.write(data_str)
                    self.ins_data_publisher(data)
                    
                elif data_list[2] == b's':
                    # found inertial msg
                    imu_payload = self.ser.read(33)
                    imu_payload = imu_payload[1:-2]
                    imu_data = struct.unpack(imu_fmt, imu_payload)
                    # break into pieces
                    # gps_week = imu_data[0]
                    # gps_millisecs = imu_data[1] / 1000.
                    # a_x = imu_data[2]
                    # a_y = imu_data[3]
                    # a_z = imu_data[4]
                    # r_x = imu_data[5]
                    # r_y = imu_data[6]
                    # r_z = imu_data[7]
                    # print("imu: ", gps_week, ", ", gps_millisecs, ", ", a_x, ", ", a_y, ", ", a_z, ", ", r_x, ", ", r_y, ", ", r_z)
                    
                    # data_str = ' '.join([str(elem)+',' for elem in imu_data]) + '\n'
                    # with open('C:/Users/sgtas/Desktop/autonomous_car/imu.csv','a') as fd:
                    #     fd.write(data_str)
            
                    self.imu_data_publisher(imu_data)

            if rospy.is_shutdown():
                print('shutdown')
                self.__del__()
                break    

    def get_quaternion_from_euler(self, roll, pitch, yaw):
        """
        Convert an Euler angle to a quaternion.
        
        Input
            :param roll: The roll (rotation around x-axis) angle in radians.
            :param pitch: The pitch (rotation around y-axis) angle in radians.
            :param yaw: The yaw (rotation around z-axis) angle in radians.
        
        Output
            :return qx, qy, qz, qw: The orientation in quaternion [x,y,z,w] format
        """
        qx = np.sin(roll/2) * np.cos(pitch/2) * np.cos(yaw/2) - np.cos(roll/2) * np.sin(pitch/2) * np.sin(yaw/2)
        qy = np.cos(roll/2) * np.sin(pitch/2) * np.cos(yaw/2) + np.sin(roll/2) * np.cos(pitch/2) * np.sin(yaw/2)
        qz = np.cos(roll/2) * np.cos(pitch/2) * np.sin(yaw/2) - np.sin(roll/2) * np.sin(pitch/2) * np.cos(yaw/2)
        qw = np.cos(roll/2) * np.cos(pitch/2) * np.cos(yaw/2) + np.sin(roll/2) * np.sin(pitch/2) * np.sin(yaw/2)
        
        return [qx, qy, qz, qw]

    def ins_data_publisher(self, data):
        # print("data: ", data)
        t_now = rospy.Time.now()
        msg = String()
        st = ''
        for d in data:
            st += str(d) + ', '

        msg.data = st
        self.ins_string_pub.publish(msg)
        
        msg = NavSatFix()
        msg.header.seq = self.ins_msg_cntr
        msg.header.stamp = t_now #data[1] / 1000
        msg.header.frame_id = "LLA"
        msg.status.status = data[2]
        msg.status.service = data[3]
        msg.latitude = data[4]
        msg.longitude = data[5]
        msg.altitude = data[6]
        p_covariance = np.zeros((3,3))
        p_covariance[0,0] = data[13]
        p_covariance[1,1] = data[14]
        p_covariance[0,0] = data[15]
        msg.position_covariance = tuple(p_covariance.ravel().tolist())
        msg.position_covariance_type = 2 # diagonal known

        self.ins_navsat_pub.publish(msg)


        # gps_week = data[0]
        # gps_millisecs = data[1] / 1000
        # ins_status = data[2]
        # ins_position_type = data[3]
        # latitude = data[4]
        # longitude = data[5]
        # height = data[6]
        # north_velocity = data[7]
        # east_velocity = data[8]
        # up_velocity = data[9]
        # roll = data[10]
        # pitch = data[11]
        # heading = data[12]
        # latitude_std = data[13]
        # longitude_std = data[14]
        # height_std = data[15]
        # north_velocity_std = data[16]
        # east_velocity_std = data[17]
        # up_velocity_std = data[18]
        # roll_std = data[19]
        # pitch_std = data[20]
        # heading_std = data[21]

        lat_2_meters = 112800.0
        lon_2_meters = 86410.0

        lat_0 = 39.43909178891161
        lon_0 =  -119.78503376574612

        msg = Odometry()
        msg.header.seq = self.ins_msg_cntr
        msg.header.stamp = t_now # data[1] / 1000
        msg.header.frame_id = "world"
        msg.child_frame_id = "car"
        msg.pose.pose.position.x = (data[5] - lon_0) * lon_2_meters
        msg.pose.pose.position.y = (data[4] - lat_0) * lat_2_meters
        msg.pose.pose.position.z = data[6]

        [qx, qy, qz, qw] = self.get_quaternion_from_euler(data[10], data[11], data[12])
        msg.pose.pose.orientation.x = qx
        msg.pose.pose.orientation.y = qy
        msg.pose.pose.orientation.z = qz
        msg.pose.pose.orientation.w = qw

        p_covariance = np.zeros((6,6))
        p_covariance[0,0] = data[14] * lon_2_meters
        p_covariance[1,1] = data[13] * lat_2_meters
        p_covariance[2,2] = data[15]
        p_covariance[3,3] = data[19]
        p_covariance[4,4] = data[20]
        p_covariance[5,5] = data[21]

        msg.pose.covariance = tuple(p_covariance.ravel().tolist())

        msg.twist.twist.linear.x = data[8]
        msg.twist.twist.linear.y = data[7]
        msg.twist.twist.linear.z = data[9]
        t_covariance = np.zeros((6,6))
        t_covariance[0,0] = data[17]
        t_covariance[1,1] = data[16]
        t_covariance[2,2] = data[18]
        msg.pose.covariance = tuple(t_covariance.ravel().tolist())
        
        self.ins_odom_pub.publish(msg)
        self.ins_msg_cntr += 1

    def imu_data_publisher(self, imu_data):
        # gps_week = imu_data[0]
        # gps_millisecs = imu_data[1] / 1000.
        # a_x = imu_data[2]
        # a_y = imu_data[3]
        # a_z = imu_data[4]
        # r_x = imu_data[5]
        # r_y = imu_data[6]
        # r_z = imu_data[7]


        msg = Imu()
        msg.header.seq = self.imu_msg_cntr
        msg.header.stamp = rospy.Time.now()#imu_data[1] / 1000
        msg.header.frame_id = "car"

        msg.linear_acceleration.x = imu_data[2]
        msg.linear_acceleration.y = imu_data[3]
        msg.linear_acceleration.z = imu_data[4]

        msg.angular_velocity.x = imu_data[5]
        msg.angular_velocity.y = imu_data[6]
        msg.angular_velocity.z = imu_data[7]

        self.ins_imu_pub.publish(msg)
        self.imu_msg_cntr += 1
        
    
    def __del__(self):
        pass

if __name__ == "__main__":
    #['/dev/ttyUSB4', '/dev/ttyUSB3', '/dev/ttyUSB2', '/dev/ttyUSB1', '/dev/ttyUSB0', '/dev/ttyTHS4', '/dev/ttyTHS1'])
    print("Initializing Open_INS_Node")
    rospy.init_node("Open_INS_Interface")
    port = '/dev/ttyUSB0' # edit user's port name here
    ports = serial.tools.list_ports.comports()
    for p in ports:
        # print("p: ", p)
        # print("   p.description: ", p.description)
        # print("   p.manufacturer: ", p.manufacturer)
        # print("   p.name: ", p.name)
        # print("   p.product: ", p.product)
        # print("   p.pid: ", p.pid)
        # print("   p.serial_number: ", p.serial_number)
        # print("   p.device: ", p.device)
        # print("   p.hwid: ", p.hwid)
        if 'Quad RS232-HS' in p.product:
            print("Open_INS_Node::main: found potential RTK: ", p.device)
            # the true one is the lowest one checked and they check in order from high to low
            # so the last one *should* be the right one
            port = p.device

    print("Open_INS_Node::main: trying to connect on: ", port)
    openrtk = OpenRTK(port=port)
    print("Open_INS_Node::main: connected to RTK")
    rospy.spin()
    