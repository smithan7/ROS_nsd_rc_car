;; Auto-generated. Do not edit!


(when (boundp 'esp32_interface::Car_Control)
  (if (not (find-package "ESP32_INTERFACE"))
    (make-package "ESP32_INTERFACE"))
  (shadow 'Car_Control (find-package "ESP32_INTERFACE")))
(unless (find-package "ESP32_INTERFACE::CAR_CONTROL")
  (make-package "ESP32_INTERFACE::CAR_CONTROL"))

(in-package "ROS")
;;//! \htmlinclude Car_Control.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass esp32_interface::Car_Control
  :super ros::object
  :slots (_header _desired_steering_angle _desired_acceleration _desired_speed ))

(defmethod esp32_interface::Car_Control
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:desired_steering_angle __desired_steering_angle) 0.0)
    ((:desired_acceleration __desired_acceleration) 0.0)
    ((:desired_speed __desired_speed) 0.0)
    )
   (send-super :init)
   (setq _header __header)
   (setq _desired_steering_angle (float __desired_steering_angle))
   (setq _desired_acceleration (float __desired_acceleration))
   (setq _desired_speed (float __desired_speed))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:desired_steering_angle
   (&optional __desired_steering_angle)
   (if __desired_steering_angle (setq _desired_steering_angle __desired_steering_angle)) _desired_steering_angle)
  (:desired_acceleration
   (&optional __desired_acceleration)
   (if __desired_acceleration (setq _desired_acceleration __desired_acceleration)) _desired_acceleration)
  (:desired_speed
   (&optional __desired_speed)
   (if __desired_speed (setq _desired_speed __desired_speed)) _desired_speed)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; float32 _desired_steering_angle
    4
    ;; float32 _desired_acceleration
    4
    ;; float32 _desired_speed
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; float32 _desired_steering_angle
       (sys::poke _desired_steering_angle (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _desired_acceleration
       (sys::poke _desired_acceleration (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _desired_speed
       (sys::poke _desired_speed (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; float32 _desired_steering_angle
     (setq _desired_steering_angle (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _desired_acceleration
     (setq _desired_acceleration (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _desired_speed
     (setq _desired_speed (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get esp32_interface::Car_Control :md5sum-) "8f9b642cbe95f516badef7111c9048be")
(setf (get esp32_interface::Car_Control :datatype-) "esp32_interface/Car_Control")
(setf (get esp32_interface::Car_Control :definition-)
      "std_msgs/Header header
float32 desired_steering_angle
float32 desired_acceleration
float32 desired_speed


================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

")



(provide :esp32_interface/Car_Control "8f9b642cbe95f516badef7111c9048be")


