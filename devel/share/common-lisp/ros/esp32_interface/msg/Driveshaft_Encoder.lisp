; Auto-generated. Do not edit!


(cl:in-package esp32_interface-msg)


;//! \htmlinclude Driveshaft_Encoder.msg.html

(cl:defclass <Driveshaft_Encoder> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (rpm
    :reader rpm
    :initarg :rpm
    :type cl:float
    :initform 0.0))
)

(cl:defclass Driveshaft_Encoder (<Driveshaft_Encoder>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Driveshaft_Encoder>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Driveshaft_Encoder)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name esp32_interface-msg:<Driveshaft_Encoder> is deprecated: use esp32_interface-msg:Driveshaft_Encoder instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Driveshaft_Encoder>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader esp32_interface-msg:header-val is deprecated.  Use esp32_interface-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'rpm-val :lambda-list '(m))
(cl:defmethod rpm-val ((m <Driveshaft_Encoder>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader esp32_interface-msg:rpm-val is deprecated.  Use esp32_interface-msg:rpm instead.")
  (rpm m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Driveshaft_Encoder>) ostream)
  "Serializes a message object of type '<Driveshaft_Encoder>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'rpm))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Driveshaft_Encoder>) istream)
  "Deserializes a message object of type '<Driveshaft_Encoder>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'rpm) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Driveshaft_Encoder>)))
  "Returns string type for a message object of type '<Driveshaft_Encoder>"
  "esp32_interface/Driveshaft_Encoder")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Driveshaft_Encoder)))
  "Returns string type for a message object of type 'Driveshaft_Encoder"
  "esp32_interface/Driveshaft_Encoder")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Driveshaft_Encoder>)))
  "Returns md5sum for a message object of type '<Driveshaft_Encoder>"
  "969d40cbc057e12ae62971e22a31432d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Driveshaft_Encoder)))
  "Returns md5sum for a message object of type 'Driveshaft_Encoder"
  "969d40cbc057e12ae62971e22a31432d")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Driveshaft_Encoder>)))
  "Returns full string definition for message of type '<Driveshaft_Encoder>"
  (cl:format cl:nil "std_msgs/Header header~%float32 rpm~%~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Driveshaft_Encoder)))
  "Returns full string definition for message of type 'Driveshaft_Encoder"
  (cl:format cl:nil "std_msgs/Header header~%float32 rpm~%~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Driveshaft_Encoder>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Driveshaft_Encoder>))
  "Converts a ROS message object to a list"
  (cl:list 'Driveshaft_Encoder
    (cl:cons ':header (header msg))
    (cl:cons ':rpm (rpm msg))
))
