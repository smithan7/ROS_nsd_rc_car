#!/usr/bin/env python

# This node takes in the INS and PWM data and then it estimates the state

import rospy
from esp32_interface.msg import PWM_Measure

from nav_msgs.msg import Odometry
from geometry_msgs.msg import Point, Pose, Quaternion, Twist, Vector3
from sensor_msgs.msg import NavSatFix, Imu
import tf

from ukf import UnscentedKalmanFilter

import numpy as np
import math
import time

g = 9.81
mph_to_mps = 0.44704
in_to_m = 0.0254
lbs_to_kg = 0.45359237

# max_steering_angle = 0.5435 # radians
# max_steering_rate = 0.3294 # radians / second
# max_speed = 140 * mph_to_mps # m/s - est limitless = 140 mph
# characteristic_velocity = 20.0 # m/s - drives side slip
# steer_damping = 1.0 / 0.3 # seconds
# accel_damping = 1.0 / 0.3 # seconds
# max_braking_accel = -1.0*g # m/s^2 - stanley is -6.0 m/s^2, est limitless = -1g
# max_forward_accel = 3.3 # m/s^2 - stanley is 1.8 m/s^2, est limitless = 3.3 m/s^2
# max_centripetal_accel = 1.0*g # m/s^2 - est limitless is 1.0g 
# length = 28.0 * in_to_m # stanley is 2.885 meters, est limitless = 28"

# mass = 17.0 * lbs_to_kg # kg
# c_y = 145.0 # lateral tire stiffness
# a = length / 2.0 # center of mass to front wheels
# b = length / 2.0 # center of mass to rear wheels

class StateEstimationNode:
    steve_has_control = True
    x = np.array([0, #0 - x position (m)
                  0, #1 - x speed (m/s)
                  0, #2 - y position (m)
                  0, #3 - y speed  (m/s)
                  0, #4 - forward speed (m/s)
                  0, #5 - forward acceleration (m/s^2)
                  0, #6 - forward jerk (m/s^3)
                  0, #7 - heading angle (rads)
                  0, #8 - heading rate (rads/s)
                  0, #9 - steering angle (rads)
                  0]) #10 - steering rate (rads/sec)
    
    xi = 0
    xdi = 1
    yi = 2
    ydi = 3
    fsi = 4
    fai = 5
    fji = 6
    hai = 7
    hri = 8
    sai = 9
    sri = 10

    def __init__(self):
        rospy.init_node('State_Estimator_Node', anonymous=True)


        # initialize from param server
        self.load_params()
        
        # ESP32 Interface pub/sub and timer callbacks
        self.steve_cmds_sub = rospy.Subscriber("steve_measured", PWM_Measure, self.steve_cmds_sub_callback)
        self.xavier_cmds_sub = rospy.Subscriber("xavier_measured", PWM_Measure, self.xavier_cmds_sub_callback)
        self.imu_sub = rospy.Subscriber("xavier_measured", PWM_Measure, self.xavier_cmds_sub_callback)
        self.ins_navsat_sub = rospy.SubscribeListener('navsat', NavSatFix, self.ins_navsat_callback)
        self.ins_imu_sub = rospy.Subscriber('imu', Imu, self.ins_imu_callback)
        self.ins_odom_sub = rospy.Subscriber('odom', Odometry, self.ins_odom_callback)
        self.esp32_time = time.time()
        self.ins_time = time.time()

        # Aceinna Interface pubs and timer callbacks
        self.odom_pub = rospy.Publisher('odom', Odometry, queue_size=10)
        self.gnss_pub = rospy.Publisher('gnss', NavSatFix, queue_size=10)
        self.odom_broadcaster = tf.TransformBroadcaster()

        rospy.Timer(rospy.Duration(1./100.), self.publish_esimtate)

    def load_params(self):
        # set initial state
        self.max_steering_angle = rospy.get_param('max_steering_angle') # radians - 0.5435 
        self.max_steering_rate = rospy.get_param('max_steering_rate') # radians / second #0.3294 
        self.max_speed = rospy.get_param('max_speed') #140 * mph_to_mps # m/s - est limitless = 140 mph
        self.characteristic_velocity = rospy.get_param('characteristic_velocity') # 20.0 # m/s - drives side slip
        self.steer_damping = rospy.get_param('steer_damping') # seconds
        self.accel_damping = rospy.get_param('accel_damping') # seconds
        self.max_braking_accel = rospy.get_param('max_braking_accel') # m/s^2 - stanley is -6.0 m/s^2, est limitless = -1g
        self.max_forward_accel = rospy.get_param('max_forward_accel') # m/s^2 - stanley is 1.8 m/s^2, est limitless = 3.3 m/s^2
        self.max_centripetal_accel = rospy.get_param('max_centripetal_accel') # m/s^2 - est limitless is 1.0g 
        self.length = rospy.get_param('car_length') # stanley is 2.885 meters, est limitless = 28"
        self.mass = rospy.get_param('car_mass') # kg
        self.c_y = rospy.get_param('lateral_tire_stiffness') # lateral tire stiffness
        self.a = self.length / 2.0 # center of mass to front wheels
        self.b = self.length / 2.0 # center of mass to rear wheels

    def steve_cmds_sub_callback(self, msg):
        ''' This subscribes to the input commands topic and saves it as received.
        It will then be saved as sent at the next timer callback to be used in the next state model update '''
        # rospy.loginfo(rospy.get_caller_id() + "Car_Simulator_Node::steve_cmds_sub_callback::msg %s", msg)
        self.steve_has_control = msg.control > 1500
        if self.steve_has_control:
            # Steve has control - pass the UKF input commands to propagate the state forward
            self.ukf.predict(dt, [msg.speed, msg.steer])

    def xaiver_cmds_sub_callback(self, msg):
        ''' This subscribes to the input commands topic and saves it as received.
        It will then be saved as sent at the next timer callback to be used in the next state model update '''
        # rospy.loginfo(rospy.get_caller_id() + "Car_Simulator_Node::xavier_cmds_sub_callback::msg %s", msg)
        if self.steve_has_control == False:
            # Xavier has control - pass the UKF input commands to propagate the state forward
            self.ukf.predict(dt, [msg.speed, msg.steer])

    def map_received_steer_to_car(self):
        ''' This maps the PWM to a steering angle assuming the PWM is perfectly centered at 1500 and in range 1000 - 2000'''
        # TODO - [1000, 2000] is ideal and might not be realistic
        return np.interp(self.received_desired_steer, [1000, 2000], [-self.max_steering_angle, self.max_steering_angle])

    def map_received_speed_to_car(self):
        ''' This maps the PWM to a steering angle assuming the PWM is perfectly centered at 1500 and in range 1000 - 2000'''
        # calculate the desired speed
        #TODO - [1000, 2000] is ideal and might not be realistic
        speed_desired = np.interp(self.received_desired_speed, [1000, 2000], [-self.max_speed, self.max_speed])
        # calculate the desired acceleration from the desired speed
        #TODO - dividing by 1s below chosed arbitrarily
        accel_desired = (speed_desired - self.get_speed()) / 1.0
        return accel_desired

if __name__ == '__main__':
    try:
        car = SimulatedCarState()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass
