#!/usr/bin/python3

import rospy
import serial
import serial.tools.list_ports
import pyubx2

from ins_interface.msg import HNR_PVT

class INS_Interface:
    ins_seq = 0

    def __init__(self):
        print("Initializing U-Blox INS")

        # port_name = self.find_ins()
        # print("port_name: ", port_name)
        # self.port = serial.Serial(port_name, baudrate=115200, timeout=1)
        # self.ubr = pyubx2.UBXReader(self.port)

        self.ins_ser = serial.Serial()
        attempts = 0
        ins_ser_open = False

        while not ins_ser_open and attempts < 50:
            if not ins_ser_open:
                try:
                    port_name = self.find_ins()
                    print("U-Blox INS found on port: ", port_name)
                    print("Attempting to connect to U-Blox INS")
                    self.port = serial.Serial(port_name, baudrate=115200, timeout=1)
                    print("Connected to U-Blox INS")
                    self.ubr = pyubx2.UBXReader(self.port)
                    print("initialized pyubx2.UBXReader")
                    ins_ser_open = True
                except:
                    print("INS_Interface::Failed to open INS serial port: ", attempts)
                    attempts += 1
        
        print("Initializing INS ROS interfaces")
        self.ins_pub = rospy.Publisher('HNR_PVT', HNR_PVT, queue_size=10)
        rospy.Timer(rospy.Duration(1.0/20.0), self.read_from_ins)
        print("INS Interface initialized")

    def find_ins(self, port=None):
        """Get the name of the port that is connected to Arduino."""
        if port is None:
            ports = serial.tools.list_ports.comports()
            for p in ports:
                print("p.manufacturer: ", p.manufacturer, " and ", p)
                if p.manufacturer is not None and "u-blox" in p.manufacturer:
                    port = p.device
        return port

    def read_from_ins(self, event=None):
        while self.port.in_waiting > 0:
            # print("in read from ins")
            (raw_data, parsed_data) = self.ubr.read()
            if isinstance(parsed_data, pyubx2.ubxmessage.UBXMessage):
                # print("parsed_data: ", parsed_data)
                msg = HNR_PVT()
                msg.header.seq = self.ins_seq
                msg.header.frame_id = '\LLA'
                msg.header.stamp = rospy.Time.now()
                self.ins_seq += 1

                msg.iTOW = parsed_data.iTOW
                msg.year = parsed_data.year
                msg.month = parsed_data.month
                msg.day = parsed_data.day
                msg.hour = parsed_data.hour
                msg.min = parsed_data.min
                msg.sec = parsed_data.second
                msg.nano = parsed_data.nano

                msg.VALID_DATE = parsed_data.validDate
                msg.VALID_TIME = parsed_data.validTime
                msg.VALID_FULLY_RESOLVED = parsed_data.fullyResolved

                msg.gpsFix = parsed_data.gpsFix
                msg.FLAGS_GNSS_FIX_OK = parsed_data.GPSfixOK
                msg.FLAGS_DIFF_SOLN = parsed_data.DiffSoln
                msg.FLAGS_WKN_SET = parsed_data.WKNSET
                msg.FLAGS_TOW_SET = parsed_data.TOWSET
                msg.FLAGS_HEAD_VEH_VALID = parsed_data.headVehValid
                # msg.reserved0 = parsed_data.reserved1
                
                msg.lon = int(parsed_data.lon*pow(10,7))
                msg.lat = int(parsed_data.lat*pow(10,7))
                msg.height = parsed_data.height
                msg.hMSL = parsed_data.hMSL
                msg.gSpeed = parsed_data.gSpeed
                msg.speed = parsed_data.speed
                msg.headMot = int(parsed_data.headMot*pow(10,5))
                msg.headVeh = int(parsed_data.headVeh*pow(10,5))
                msg.hAcc = parsed_data.hAcc
                msg.vAcc = parsed_data.vAcc
                msg.sAcc = parsed_data.sAcc
                msg.headAcc = int(parsed_data.headAcc*pow(10,5))
                # msg.reserved1 = parsed_data.reserved2

                self.ins_pub.publish(msg)

    def __del__(self):
        self.port.close()

if __name__ == '__main__':
    rospy.init_node("INS_Interface")
    # Create an instance of Temperature sensor
    ei = INS_Interface()
    # Create a ROS Timer for reading data
    rospy.spin()
