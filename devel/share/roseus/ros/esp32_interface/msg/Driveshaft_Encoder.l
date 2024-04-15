;; Auto-generated. Do not edit!


(when (boundp 'esp32_interface::Driveshaft_Encoder)
  (if (not (find-package "ESP32_INTERFACE"))
    (make-package "ESP32_INTERFACE"))
  (shadow 'Driveshaft_Encoder (find-package "ESP32_INTERFACE")))
(unless (find-package "ESP32_INTERFACE::DRIVESHAFT_ENCODER")
  (make-package "ESP32_INTERFACE::DRIVESHAFT_ENCODER"))

(in-package "ROS")
;;//! \htmlinclude Driveshaft_Encoder.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass esp32_interface::Driveshaft_Encoder
  :super ros::object
  :slots (_header _rpm ))

(defmethod esp32_interface::Driveshaft_Encoder
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:rpm __rpm) 0.0)
    )
   (send-super :init)
   (setq _header __header)
   (setq _rpm (float __rpm))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:rpm
   (&optional __rpm)
   (if __rpm (setq _rpm __rpm)) _rpm)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; float32 _rpm
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; float32 _rpm
       (sys::poke _rpm (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; float32 _rpm
     (setq _rpm (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get esp32_interface::Driveshaft_Encoder :md5sum-) "969d40cbc057e12ae62971e22a31432d")
(setf (get esp32_interface::Driveshaft_Encoder :datatype-) "esp32_interface/Driveshaft_Encoder")
(setf (get esp32_interface::Driveshaft_Encoder :definition-)
      "std_msgs/Header header
float32 rpm


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



(provide :esp32_interface/Driveshaft_Encoder "969d40cbc057e12ae62971e22a31432d")


