#!/usr/bin/env python2

# This node takes in the INS and PWM data and then it estimates the state

import rospy
from esp32_interface.msg import (PWM_Cmd, PWM_Measure, Car_Control)
from ins_interface.msg import HNR_PVT

from nav_msgs.msg import Odometry
from geometry_msgs.msg import Point, Pose, Quaternion, Twist, Vector3
from sensor_msgs.msg import NavSatFix
import tf

from ukf import *

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
        self.z_cmd_pub = rospy.Publisher('measured_commands', PWM_Measure, queue_size=10)
        self.cmd_pub = rospy.Publisher('published_commands', PWM_Cmd, queue_size=10)
        self.cmds_sub = rospy.Subscriber("input_commands", Car_Control, self.cmds_sub_callback)
        rospy.Timer(rospy.Duration(1./100.), self.read_serial_buffer)
        rospy.Timer(rospy.Duration(1./20.), self.write_serial_comands)
        self.esp32_time = time.time()
        self.ins_time = time.time()

        # Aceinna Interface pubs and timer callbacks
        self.odom_pub = rospy.Publisher('odom', Odometry, queue_size=10)
        self.gnss_pub = rospy.Publisher('gnss', NavSatFix, queue_size=10)
        self.odom_broadcaster = tf.TransformBroadcaster()
        rospy.Timer(rospy.Duration(1./100.), self.read_INS)

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

    def read_INS(self, event=None):
        ''' This replicates the Aceinna ins by publishing out a position (Odom and GNSS), however, first it must iterate
        the dynamic model with the current PWM cmds send out by the ESP32 interface.
        '''
        
        # Tic the dynamic model
        self.input_steering(self.received_desired_steer)
        self.input_accel(self.received_desired_acceleration)
        temp_time = time.time()
        dt = temp_time - self.ins_time
        # print("Car Simulator::dt: ", dt)
        self.ins_time = temp_time
        self.tic(dt)

        # Extract state data to populate tf update as well as the Odom and GNSS messages
        [x,y] = self.get_2D_pos()
        th = self.get_heading_angle()
        # print("car_simulator_node::read_INS::heading: ", th % 2.0*math.pi)
        odom_quat = tf.transformations.quaternion_from_euler(0,0,th)

        # update the odom TF
        self.odom_broadcaster.sendTransform(
            (x,y,0),
            odom_quat,
            rospy.Time.now(),
            "base_link",
            "odom"
        )

        # build and publish the odom message
        odom = Odometry()
        odom.header.stamp = rospy.Time.now()
        odom.header.frame_id = "odom"
        odom.child_frame_id = "base_link"
        odom.pose.pose = Pose(Point(x,y,0), Quaternion(*odom_quat))
        odom.pose.covariance = (np.eye(6) * np.array([1.0, 1.0, 1.0, # position in meters
                                                     0.01, 0.01, 0.01])).flatten() # orientation in radians
        # odom.pose.covariance = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        # print("p: ", odom.pose.covariance)
        vx = self.x[self.xdi]
        vy = self.x[self.ydi]
        # print("car_simulator_node::read_INS:speed: ", self.x[self.fsi])
        vTh = self.get_heading_rate()
        odom.twist.twist = Twist(Vector3(vx,vy,0), Vector3(0,0,vTh))
        odom.twist.covariance = (np.eye(6) * np.array([0.1, 0.1, 0.1, # velocities in m/s
                                                      0.001, 0.001, 0.001])).flatten() # orientations in rad/s
        # print("t: ", odom.twist.covariance)
        self.odom_pub.publish(odom)

        # build and publish the GNSS message
        gnss = NavSatFix()
        gnss.header.stamp = rospy.Time.now()
        gnss.header.frame_id = "gnss"
        # gnss.status = 0
        # gnss.service = 1 # use GPS even though it is likely multiple
        gnss.latitude = -1.0 # in degrees # TODO
        gnss.longitude = -1.0 # in degrees # TODO
        gnss.altitude = 0.0 # in meters # TODO
        gnss.position_covariance = (np.eye(3) * np.array([1.5, 1.5, 1.5])).flatten()
        gnss.position_covariance_type = gnss.COVARIANCE_TYPE_APPROXIMATED # Covariance for GNSS is approximated
        self.gnss_pub.publish(gnss)

    def cmds_sub_callback(self, msg):
        ''' This subscribes to the input commands topic and saves it as received.
        It will then be saved as sent at the next timer callback to be used in the next state model update '''
        # rospy.loginfo(rospy.get_caller_id() + "Car_Simulator_Node::cmds_sub_callback::msg %s", msg)
        self.received_desired_speed = msg.desired_speed
        self.received_desired_steer = msg.desired_steering_angle
        self.received_desired_acceleration = msg.desired_acceleration
        self.received_input = True

    def read_serial_buffer(self, event=None):
        ''' This replicates measuring the status of the PWM commands of the car and generates two messages
        1. PWM_Measure - this is what PWM messages have been received by the ESP32 from the MUX
            - This is either what I sent out or what the driver did
        2. PWM_Cmd - this is what I tried to send out
            - useful for debugging the ESP32
        '''
        # General data
        z_time = time.time() - self.esp32_time
        # Prep PWM_Measure and send
        msg = PWM_Measure()
        msg.header.stamp = rospy.Time.now()
        msg.time = z_time*pow(10,6)
        msg.status = 1
        msg.control = 1 # TODO - make a sub to be able to take this over and have a human drive via keyboard
        msg.steer = self.sent_steer
        msg.speed = self.sent_speed
        self.z_cmd_pub.publish(msg)
        # Prep PWM_Cmd and send
        msg = PWM_Cmd()
        msg.header.stamp = rospy.Time.now()
        msg.time = z_time*pow(10,6)
        msg.steer = self.sent_steer
        msg.speed = self.sent_speed
        self.cmd_pub.publish(msg)

    def write_serial_comands(self, event=None):
        ''' This replicates sending commands into the ESP32 and setting the corresponding RC Cmds into the ESP32
        It should take in whatever the current RC commands are and store them as sent.
        Then, when the model is called to 'tick' it will pull the most recent 'sent' RC commands '''
        # if I received a new input set it to be sent - which really means called by the dynamic model
        if self.received_input:
            self.sent_steer = self.map_received_steer_to_car()
            self.sent_speed = self.map_received_speed_to_car()
            self.received_input = False

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

    def input_steering(self, u_steer):
        '''Take in a desired steering angle and get the resulting steering rate'''
        # print("car_simulator::input_steer::u_steer: ", u_steer)
        # ensure the desired steering angle is possible 
        u_steer = clamp(u_steer, -self.max_steering_angle, self.max_steering_angle)
        # set the rate - will push to actual steering angle in update function
        self.x[self.sri] = self.steer_damping * (u_steer - self.x[self.sai])
        # ensure the resulting steering rate is possible
        self.x[self.sri] = clamp(self.x[self.sri], -self.max_steering_rate, self.max_steering_rate)
        # print("car_simulator::input_steer::steering input: ", self.x[self.sri])

    def input_accel(self, u_accel):
        '''Take in a desired acceleration and get the resulting acceleration rate (jerk)'''
        # print("car_simulator::input_accel::u_accel: ", u_accel)
        # ensure the desired acceleration is possible 
        u_accel = clamp(u_accel, self.max_braking_accel , self.max_forward_accel)
        # set the rate - will push to actual steering angle in update function
        self.x[self.fji] = self.steer_damping * (u_accel - self.x[self.fai])
        # print("car_simulator::input_accel::accel input: ", self.x[self.fji])
        
    def tic(self, dt):
        # 
        Gss = 1 / (1.0 + (self.x[self.fsi]/self.characteristic_velocity)**2)
        A = np.array([[1.0,  dt,   0,  0,                                                    0,   0,         0,   0,  0,   0,   0], # x_k+1 = x_k + xdot*dt
                      [  0,   0,   0,  0,                           math.cos(self.x[self.hai]),   0,         0,   0,  0,   0,   0], # xdot = forward speed * cos(heading)
                      [  0,   0, 1.0, dt,                                                    0,   0,         0,   0,  0,   0,   0], # y_k+1 = y_k + ydot * dt 
                      [  0,   0,   0,  0,                           math.sin(self.x[self.hai]),   0,         0,   0,  0,   0,   0], # ydot = forward speed * sin(heading)
                      [  0,   0,   0,  0,                                                  1.0,  dt, 0.5*dt**2,   0,  0,   0,   0], # forward speed_k+1 = forward speed_k + forward acceleration * dt + 0.5*forward jerk_k * dt^2 
                      [  0,   0,   0,  0,                                                    0, 1.0,        dt,   0,  0,   0,   0], # forward acceleration_k+1 = forward_acceleration_k + forward_jerk * dt
                      [  0,   0,   0,  0,                                                    0,   0,       1.0,   0,  0,   0,   0], # forward jerk_k+1 = forward_jerk_k
                      [  0,   0,   0,  0,                                                    0,   0,         0, 1.0, dt,   0,   0], # heading angle_k+1 = heading_angle_k + heading_angle rate_k * dt
                      [  0,   0,   0,  0, math.tan(self.x[self.sai])*Gss/self.length,   0,         0,   0,  0,   0,   0], # heading angle rate_k+1= forward_speed_k * 1/L*tan(steering_angle)*Gss
                      [  0,   0,   0,  0,                                                    0,   0,         0,   0,  0, 1.0,  dt], # steering angle_k+1 = steering angle_k + steering angle_rate_k * dt
                      [  0,   0,   0,  0,                                                    0,   0,         0,   0,  0,   0, 1.0]]) # steering angle rate_k+1 = steering angle rate_k
        
        self.x = np.matmul(A, self.x)
        
    def get_steering_angle(self):
        return self.x[self.sai]
    
    def get_steering_rate(self):
        return self.x[self.sri]
    
    def get_heading_angle(self):
        return self.x[self.hai]
    
    def get_heading_rate(self):
        return self.x[self.hri]
    
    def get_speed(self):
        return self.x[self.fsi]
    
    def get_2D_pos(self):
        return [self.x[self.xi], self.x[self.yi]]

if __name__ == '__main__':
    try:
        car = SimulatedCarState()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass
