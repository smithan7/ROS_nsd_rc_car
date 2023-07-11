; Auto-generated. Do not edit!


(cl:in-package esp32_interface-msg)


;//! \htmlinclude Car_Control.msg.html

(cl:defclass <Car_Control> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (desired_steering_angle
    :reader desired_steering_angle
    :initarg :desired_steering_angle
    :type cl:float
    :initform 0.0)
   (desired_acceleration
    :reader desired_acceleration
    :initarg :desired_acceleration
    :type cl:float
    :initform 0.0)
   (desired_speed
    :reader desired_speed
    :initarg :desired_speed
    :type cl:float
    :initform 0.0))
)

(cl:defclass Car_Control (<Car_Control>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Car_Control>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Car_Control)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name esp32_interface-msg:<Car_Control> is deprecated: use esp32_interface-msg:Car_Control instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Car_Control>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader esp32_interface-msg:header-val is deprecated.  Use esp32_interface-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'desired_steering_angle-val :lambda-list '(m))
(cl:defmethod desired_steering_angle-val ((m <Car_Control>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader esp32_interface-msg:desired_steering_angle-val is deprecated.  Use esp32_interface-msg:desired_steering_angle instead.")
  (desired_steering_angle m))

(cl:ensure-generic-function 'desired_acceleration-val :lambda-list '(m))
(cl:defmethod desired_acceleration-val ((m <Car_Control>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader esp32_interface-msg:desired_acceleration-val is deprecated.  Use esp32_interface-msg:desired_acceleration instead.")
  (desired_acceleration m))

(cl:ensure-generic-function 'desired_speed-val :lambda-list '(m))
(cl:defmethod desired_speed-val ((m <Car_Control>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader esp32_interface-msg:desired_speed-val is deprecated.  Use esp32_interface-msg:desired_speed instead.")
  (desired_speed m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Car_Control>) ostream)
  "Serializes a message object of type '<Car_Control>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'desired_steering_angle))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'desired_acceleration))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'desired_speed))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Car_Control>) istream)
  "Deserializes a message object of type '<Car_Control>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'desired_steering_angle) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'desired_acceleration) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'desired_speed) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Car_Control>)))
  "Returns string type for a message object of type '<Car_Control>"
  "esp32_interface/Car_Control")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Car_Control)))
  "Returns string type for a message object of type 'Car_Control"
  "esp32_interface/Car_Control")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Car_Control>)))
  "Returns md5sum for a message object of type '<Car_Control>"
  "8f9b642cbe95f516badef7111c9048be")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Car_Control)))
  "Returns md5sum for a message object of type 'Car_Control"
  "8f9b642cbe95f516badef7111c9048be")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Car_Control>)))
  "Returns full string definition for message of type '<Car_Control>"
  (cl:format cl:nil "std_msgs/Header header~%float32 desired_steering_angle~%float32 desired_acceleration~%float32 desired_speed~%~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Car_Control)))
  "Returns full string definition for message of type 'Car_Control"
  (cl:format cl:nil "std_msgs/Header header~%float32 desired_steering_angle~%float32 desired_acceleration~%float32 desired_speed~%~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Car_Control>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Car_Control>))
  "Converts a ROS message object to a list"
  (cl:list 'Car_Control
    (cl:cons ':header (header msg))
    (cl:cons ':desired_steering_angle (desired_steering_angle msg))
    (cl:cons ':desired_acceleration (desired_acceleration msg))
    (cl:cons ':desired_speed (desired_speed msg))
))
