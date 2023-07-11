#!/usr/bin/env python

import rospy
import tf
from nav_msgs.msg import Odometry
from geometry_msgs.msg import Point, Pose, Quaternion, Twist, Vector3
from visualization_msgs.msg import Marker, MarkerArray


import math
import numpy as np

from esp32_interface.msg import Car_Control
from Track import Track
from PID_Controller import PID
from CarController import CarController


class Stanley_Controller:
    steer_cmd = 0.0
    speed_cmd = 0.0

    def __init__(self):
        rospy.loginfo("Stanley Controller::loading Track")
        laguna_seca = "/home/andy/autopilot/not-so-dumb-rc-car/AutonomousCar/data/track_data.csv"
        test_circle_10m = "../data/test_circle_10.0_radius.csv"
        test_circle_50m = "../data/test_circle_50.0_radius.csv"
        test_circle_100m = "../data/test_circle_100m_radius.csv"
        self.track = Track(laguna_seca)
        rospy.loginfo("Stanley Controller::loaded Track")

        rospy.loginfo("Stanley Controller::Load Params")
        car_max_speed = rospy.get_param('max_speed') #140 * mph_to_mps # m/s - est limitless = 140 mph
        car_max_braking_accel = rospy.get_param('max_braking_accel') # m/s^2 - stanley is -6.0 m/s^2, est limitless = -1g
        car_max_forward_accel = rospy.get_param('max_forward_accel') # m/s^2 - stanley is 1.8 m/s^2, est limitless = 3.3 m/s^2
        car_max_centripetal_accel = rospy.get_param('max_centripetal_accel') # m/s^2 - est limitless is 1.0g 
        rospy.loginfo("Stanley Controller::Loaded Params")

        rospy.loginfo("Stanley Controller::Tuning Track Speeds")
        '''THIS IS WHERE I TUNE THE TRACK SPEEDS'''
        # get the radius of curvature for the track and then set the speed limit based on the current carParams' max centripetal acceleration
        # this sets the maximum acceleration at any given point but it does not account for the NEXT edge on the track where I might need to go slower
        self.track.get_speed_limits_from_roc(car_max_speed, car_max_centripetal_accel)
        # this back propagates speed limits to set the desired speed to ensure that, based on the carParams' max braking, I will be slow enough at the next edge
        self.track.back_propagate_speed_limits_to_set_speed(car_max_braking_accel=car_max_braking_accel)
        # the above is not great on long straight stretches and it does not try and increase the radius of the corners
        '''END WHERE I TUNE TRACK SPEEDS'''
        rospy.loginfo("Stanley Controller::Tuned Track Speeds")
        rospy.loginfo("Length of Track: " + str(len(self.track.track_df)) + " should be 205 for Laguna Seca")
        
        self.controller = CarController()

        # tune the speed controller
        self.controller.speed_pid.kp = 2.0
        # controller.speed_pid.ki = 0.01
        # tune the steering controller
        self.controller.steer_pid.kp = 8.0
        self.controller.steer_pid.kd = 500.0
        # cross track component
        self.cross_track_error_gain = 3.0
        self.cross_track_error_soft = 1.0

        # set values for the track interface
        self.nearest_edge = 0
        self.car_x = 0
        self.car_y = 0
        self.car_speed = 0
        self.car_heading = 0

        self.plot_path_as_marker_Array()

        # setup ROS interfaces
        self.cmd_pub = rospy.Publisher('input_commands', Car_Control, queue_size=10)
        self.pos_sub = rospy.Subscriber('odom', Odometry, self.odom_callback)
        self.cmd_timer = rospy.Timer(rospy.Duration(1.0/20.0), self.cmd_timer_callback)
    
    def plot_path_as_marker_Array(self):
        '''
        Plot the path as a marker array so I can see it in RVIZ
        '''
        #plt.plot([self.track_df["outer_x"].tail(1), self.track_df["outer_x"][0]], [self.track_df["outer_y"].tail(1), self.track_df["outer_y"][0]], 'k')
        self.marker_pub = rospy.Publisher('marker', MarkerArray, latch=True, queue_size=10)
        self.track_markers = MarkerArray()

        for index, row in self.track.track_df.iterrows():

            marker = Marker()

            marker.id = index
            marker.header.stamp = rospy.get_rostime()
            marker.header.frame_id = "/odom"
            marker.type = marker.SPHERE
            marker.action = marker.ADD
            marker.scale = Vector3(1.0, 1.0, 3.0)
            marker.color.r = 1.0
            marker.color.a = 1.0
            marker.pose.orientation.w = 1.0
            marker.pose.position.x = row["outer_x"]
            marker.pose.position.y = row["outer_y"]
            marker.pose.position.z = 0.0

            self.track_markers.markers.append(marker)


            marker = Marker()

            marker.id = index + len(self.track.track_df)
            marker.header.stamp = rospy.get_rostime()
            marker.header.frame_id = "/odom"
            marker.type = marker.SPHERE
            marker.action = marker.ADD
            marker.scale = Vector3(1.0, 1.0, 3.0)
            marker.color.r = 1.0
            marker.color.a = 1.0
            marker.pose.orientation.w = 1.0
            marker.pose.position.x = row["inner_x"]
            marker.pose.position.y = row["inner_y"]
            marker.pose.position.z = 0.0

            self.track_markers.markers.append(marker)


        self.marker_pub.publish(self.track_markers)


    def odom_callback(self, msg):
        ''' Odom callback takes in the position from the INS...
            and stores it internally for use'''
        self.car_x = msg.pose.pose.position.x
        self.car_y = msg.pose.pose.position.y
        self.car_speed = math.sqrt(math.pow(msg.twist.twist.linear.x,2) + math.pow(msg.twist.twist.linear.y,2))
        (_, _, self.car_heading) = tf.transformations.euler_from_quaternion ([msg.pose.pose.orientation.x, msg.pose.pose.orientation.y, msg.pose.pose.orientation.z, msg.pose.pose.orientation.w])
        # print("stanley_controller::odom_callback::car.heading: ", self.car_heading % 2.0*math.pi)
        # print("stanley_controller::odom_callback::car.speed: ", self.car_speed)
        
    def cmd_timer_callback(self, event=None):
        ''' Triggers at ~20 Hz to:
         1 - identify where on the path the car is
         2 - identify a corrective action to track the path
         3 - publishes out the desired steering angle / speed for the ESP32 to push to the car
        '''
        
        self.nearest_edge, cross_track_error, dist_along_edge = self.track.find_nearest_edge_with_seed([self.car_x, self.car_y], self.nearest_edge, window_size=2)
        desired_speed = self.track.track_df['speed'][self.nearest_edge] * 0.5
        # print("Stanley_Controllet::desired speed: ", desired_speed)
        a_des = self.controller.speed_pid.tic(self.car_speed, desired_speed)
        # print("Stanley_Controllet::desired acceleration: ", a_des)
        # get the desired heading from the track - uses some linear interpolation from adjacent edges to smooth it out some - but it's not great... could be smoother
        desired_heading = self.track.interp_between_edges(self.nearest_edge, dist_along_edge, 'heading')
        # ensure that the heading is aligned with the car - if car is at 1deg and track is at 359deg it corrects the track to -1deg to stop the car from turning around
        desired_heading = self.track.bearing_align(0.0, desired_heading)#track.track_df.iloc[nearest_edge]["heading"])
        # print("Stanley_Controllet::desired heading: ", desired_heading)
        # get the desired steering input based on the current car heading and the desired 
        # print("stanley_controller_node::INS_callback::desired_heading: ", desired_heading)
        # print("stanley_controller_node::INS_callback::car_heading: ", self.car_heading)
        steer_des = self.controller.steer_pid.tic(self.car_heading, desired_heading)
        # print("stanley_controller_node::INS_callback::desired_steering: ", steer_des)
    
        # get the cross track error direction and correction factor
        cross_track_error *= self.track.find_cross_track_error_to_edge(self.nearest_edge, [self.car_x, self.car_y])
        cross_track_error_correction = self.cross_track_error_gain * math.atan(cross_track_error / (self.cross_track_error_soft + max(desired_speed, self.car_speed)))
        
        # add the desired steering angle based on heading error and cross track error
        steer_input = steer_des + cross_track_error_correction
        # print("Stanley_Controllet::desired steering: ", steer_input)
        # Prep PWM_Cmd and send
        msg = Car_Control()
        msg.header.stamp = rospy.Time.now()
        msg.desired_steering_angle = steer_input
        msg.desired_acceleration = a_des
        msg.desired_speed = desired_speed
        self.cmd_pub.publish(msg)

if __name__ == '__main__':
    try:
        rospy.init_node('Stanley_Controller', anonymous=True)
        stan = Stanley_Controller()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass
