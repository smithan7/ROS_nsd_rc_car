#!/usr/bin/env python2

import rospy
from esp32_interface.msg import PWM_Cmd

class Simple_Controller:
    steer_cmd = 0.0
    speed_cmd = 0.0

def talker():
    pub = rospy.Publisher('input_commands', PWM_Cmd, queue_size=10)
    rospy.init_node('Simple_Controller', anonymous=True)
    rate = rospy.Rate(10) # 10hz
    while not rospy.is_shutdown():
        msg = PWM_Cmd()
        msg.steer = 1500
        msg.speed = 1500
        pub.publish(msg)
        rate.sleep()

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass
