; Auto-generated. Do not edit!


(cl:in-package ins_interface-msg)


;//! \htmlinclude HNR_PVT.msg.html

(cl:defclass <HNR_PVT> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (iTOW
    :reader iTOW
    :initarg :iTOW
    :type cl:integer
    :initform 0)
   (year
    :reader year
    :initarg :year
    :type cl:fixnum
    :initform 0)
   (month
    :reader month
    :initarg :month
    :type cl:fixnum
    :initform 0)
   (day
    :reader day
    :initarg :day
    :type cl:fixnum
    :initform 0)
   (hour
    :reader hour
    :initarg :hour
    :type cl:fixnum
    :initform 0)
   (min
    :reader min
    :initarg :min
    :type cl:fixnum
    :initform 0)
   (sec
    :reader sec
    :initarg :sec
    :type cl:fixnum
    :initform 0)
   (valid
    :reader valid
    :initarg :valid
    :type cl:fixnum
    :initform 0)
   (VALID_DATE
    :reader VALID_DATE
    :initarg :VALID_DATE
    :type cl:fixnum
    :initform 0)
   (VALID_TIME
    :reader VALID_TIME
    :initarg :VALID_TIME
    :type cl:fixnum
    :initform 0)
   (VALID_FULLY_RESOLVED
    :reader VALID_FULLY_RESOLVED
    :initarg :VALID_FULLY_RESOLVED
    :type cl:fixnum
    :initform 0)
   (VALID_MAG
    :reader VALID_MAG
    :initarg :VALID_MAG
    :type cl:fixnum
    :initform 0)
   (nano
    :reader nano
    :initarg :nano
    :type cl:integer
    :initform 0)
   (gpsFix
    :reader gpsFix
    :initarg :gpsFix
    :type cl:fixnum
    :initform 0)
   (flags
    :reader flags
    :initarg :flags
    :type cl:fixnum
    :initform 0)
   (FLAGS_GNSS_FIX_OK
    :reader FLAGS_GNSS_FIX_OK
    :initarg :FLAGS_GNSS_FIX_OK
    :type cl:fixnum
    :initform 0)
   (FLAGS_DIFF_SOLN
    :reader FLAGS_DIFF_SOLN
    :initarg :FLAGS_DIFF_SOLN
    :type cl:fixnum
    :initform 0)
   (FLAGS_WKN_SET
    :reader FLAGS_WKN_SET
    :initarg :FLAGS_WKN_SET
    :type cl:fixnum
    :initform 0)
   (FLAGS_TOW_SET
    :reader FLAGS_TOW_SET
    :initarg :FLAGS_TOW_SET
    :type cl:fixnum
    :initform 0)
   (FLAGS_HEAD_VEH_VALID
    :reader FLAGS_HEAD_VEH_VALID
    :initarg :FLAGS_HEAD_VEH_VALID
    :type cl:fixnum
    :initform 0)
   (reserved0
    :reader reserved0
    :initarg :reserved0
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 2 :element-type 'cl:fixnum :initial-element 0))
   (lon
    :reader lon
    :initarg :lon
    :type cl:integer
    :initform 0)
   (lat
    :reader lat
    :initarg :lat
    :type cl:integer
    :initform 0)
   (height
    :reader height
    :initarg :height
    :type cl:integer
    :initform 0)
   (hMSL
    :reader hMSL
    :initarg :hMSL
    :type cl:integer
    :initform 0)
   (gSpeed
    :reader gSpeed
    :initarg :gSpeed
    :type cl:integer
    :initform 0)
   (speed
    :reader speed
    :initarg :speed
    :type cl:integer
    :initform 0)
   (headMot
    :reader headMot
    :initarg :headMot
    :type cl:integer
    :initform 0)
   (headVeh
    :reader headVeh
    :initarg :headVeh
    :type cl:integer
    :initform 0)
   (hAcc
    :reader hAcc
    :initarg :hAcc
    :type cl:integer
    :initform 0)
   (vAcc
    :reader vAcc
    :initarg :vAcc
    :type cl:integer
    :initform 0)
   (sAcc
    :reader sAcc
    :initarg :sAcc
    :type cl:integer
    :initform 0)
   (headAcc
    :reader headAcc
    :initarg :headAcc
    :type cl:integer
    :initform 0)
   (reserved1
    :reader reserved1
    :initarg :reserved1
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 4 :element-type 'cl:fixnum :initial-element 0)))
)

(cl:defclass HNR_PVT (<HNR_PVT>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <HNR_PVT>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'HNR_PVT)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ins_interface-msg:<HNR_PVT> is deprecated: use ins_interface-msg:HNR_PVT instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:header-val is deprecated.  Use ins_interface-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'iTOW-val :lambda-list '(m))
(cl:defmethod iTOW-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:iTOW-val is deprecated.  Use ins_interface-msg:iTOW instead.")
  (iTOW m))

(cl:ensure-generic-function 'year-val :lambda-list '(m))
(cl:defmethod year-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:year-val is deprecated.  Use ins_interface-msg:year instead.")
  (year m))

(cl:ensure-generic-function 'month-val :lambda-list '(m))
(cl:defmethod month-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:month-val is deprecated.  Use ins_interface-msg:month instead.")
  (month m))

(cl:ensure-generic-function 'day-val :lambda-list '(m))
(cl:defmethod day-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:day-val is deprecated.  Use ins_interface-msg:day instead.")
  (day m))

(cl:ensure-generic-function 'hour-val :lambda-list '(m))
(cl:defmethod hour-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:hour-val is deprecated.  Use ins_interface-msg:hour instead.")
  (hour m))

(cl:ensure-generic-function 'min-val :lambda-list '(m))
(cl:defmethod min-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:min-val is deprecated.  Use ins_interface-msg:min instead.")
  (min m))

(cl:ensure-generic-function 'sec-val :lambda-list '(m))
(cl:defmethod sec-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:sec-val is deprecated.  Use ins_interface-msg:sec instead.")
  (sec m))

(cl:ensure-generic-function 'valid-val :lambda-list '(m))
(cl:defmethod valid-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:valid-val is deprecated.  Use ins_interface-msg:valid instead.")
  (valid m))

(cl:ensure-generic-function 'VALID_DATE-val :lambda-list '(m))
(cl:defmethod VALID_DATE-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:VALID_DATE-val is deprecated.  Use ins_interface-msg:VALID_DATE instead.")
  (VALID_DATE m))

(cl:ensure-generic-function 'VALID_TIME-val :lambda-list '(m))
(cl:defmethod VALID_TIME-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:VALID_TIME-val is deprecated.  Use ins_interface-msg:VALID_TIME instead.")
  (VALID_TIME m))

(cl:ensure-generic-function 'VALID_FULLY_RESOLVED-val :lambda-list '(m))
(cl:defmethod VALID_FULLY_RESOLVED-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:VALID_FULLY_RESOLVED-val is deprecated.  Use ins_interface-msg:VALID_FULLY_RESOLVED instead.")
  (VALID_FULLY_RESOLVED m))

(cl:ensure-generic-function 'VALID_MAG-val :lambda-list '(m))
(cl:defmethod VALID_MAG-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:VALID_MAG-val is deprecated.  Use ins_interface-msg:VALID_MAG instead.")
  (VALID_MAG m))

(cl:ensure-generic-function 'nano-val :lambda-list '(m))
(cl:defmethod nano-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:nano-val is deprecated.  Use ins_interface-msg:nano instead.")
  (nano m))

(cl:ensure-generic-function 'gpsFix-val :lambda-list '(m))
(cl:defmethod gpsFix-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:gpsFix-val is deprecated.  Use ins_interface-msg:gpsFix instead.")
  (gpsFix m))

(cl:ensure-generic-function 'flags-val :lambda-list '(m))
(cl:defmethod flags-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:flags-val is deprecated.  Use ins_interface-msg:flags instead.")
  (flags m))

(cl:ensure-generic-function 'FLAGS_GNSS_FIX_OK-val :lambda-list '(m))
(cl:defmethod FLAGS_GNSS_FIX_OK-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:FLAGS_GNSS_FIX_OK-val is deprecated.  Use ins_interface-msg:FLAGS_GNSS_FIX_OK instead.")
  (FLAGS_GNSS_FIX_OK m))

(cl:ensure-generic-function 'FLAGS_DIFF_SOLN-val :lambda-list '(m))
(cl:defmethod FLAGS_DIFF_SOLN-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:FLAGS_DIFF_SOLN-val is deprecated.  Use ins_interface-msg:FLAGS_DIFF_SOLN instead.")
  (FLAGS_DIFF_SOLN m))

(cl:ensure-generic-function 'FLAGS_WKN_SET-val :lambda-list '(m))
(cl:defmethod FLAGS_WKN_SET-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:FLAGS_WKN_SET-val is deprecated.  Use ins_interface-msg:FLAGS_WKN_SET instead.")
  (FLAGS_WKN_SET m))

(cl:ensure-generic-function 'FLAGS_TOW_SET-val :lambda-list '(m))
(cl:defmethod FLAGS_TOW_SET-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:FLAGS_TOW_SET-val is deprecated.  Use ins_interface-msg:FLAGS_TOW_SET instead.")
  (FLAGS_TOW_SET m))

(cl:ensure-generic-function 'FLAGS_HEAD_VEH_VALID-val :lambda-list '(m))
(cl:defmethod FLAGS_HEAD_VEH_VALID-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:FLAGS_HEAD_VEH_VALID-val is deprecated.  Use ins_interface-msg:FLAGS_HEAD_VEH_VALID instead.")
  (FLAGS_HEAD_VEH_VALID m))

(cl:ensure-generic-function 'reserved0-val :lambda-list '(m))
(cl:defmethod reserved0-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:reserved0-val is deprecated.  Use ins_interface-msg:reserved0 instead.")
  (reserved0 m))

(cl:ensure-generic-function 'lon-val :lambda-list '(m))
(cl:defmethod lon-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:lon-val is deprecated.  Use ins_interface-msg:lon instead.")
  (lon m))

(cl:ensure-generic-function 'lat-val :lambda-list '(m))
(cl:defmethod lat-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:lat-val is deprecated.  Use ins_interface-msg:lat instead.")
  (lat m))

(cl:ensure-generic-function 'height-val :lambda-list '(m))
(cl:defmethod height-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:height-val is deprecated.  Use ins_interface-msg:height instead.")
  (height m))

(cl:ensure-generic-function 'hMSL-val :lambda-list '(m))
(cl:defmethod hMSL-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:hMSL-val is deprecated.  Use ins_interface-msg:hMSL instead.")
  (hMSL m))

(cl:ensure-generic-function 'gSpeed-val :lambda-list '(m))
(cl:defmethod gSpeed-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:gSpeed-val is deprecated.  Use ins_interface-msg:gSpeed instead.")
  (gSpeed m))

(cl:ensure-generic-function 'speed-val :lambda-list '(m))
(cl:defmethod speed-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:speed-val is deprecated.  Use ins_interface-msg:speed instead.")
  (speed m))

(cl:ensure-generic-function 'headMot-val :lambda-list '(m))
(cl:defmethod headMot-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:headMot-val is deprecated.  Use ins_interface-msg:headMot instead.")
  (headMot m))

(cl:ensure-generic-function 'headVeh-val :lambda-list '(m))
(cl:defmethod headVeh-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:headVeh-val is deprecated.  Use ins_interface-msg:headVeh instead.")
  (headVeh m))

(cl:ensure-generic-function 'hAcc-val :lambda-list '(m))
(cl:defmethod hAcc-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:hAcc-val is deprecated.  Use ins_interface-msg:hAcc instead.")
  (hAcc m))

(cl:ensure-generic-function 'vAcc-val :lambda-list '(m))
(cl:defmethod vAcc-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:vAcc-val is deprecated.  Use ins_interface-msg:vAcc instead.")
  (vAcc m))

(cl:ensure-generic-function 'sAcc-val :lambda-list '(m))
(cl:defmethod sAcc-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:sAcc-val is deprecated.  Use ins_interface-msg:sAcc instead.")
  (sAcc m))

(cl:ensure-generic-function 'headAcc-val :lambda-list '(m))
(cl:defmethod headAcc-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:headAcc-val is deprecated.  Use ins_interface-msg:headAcc instead.")
  (headAcc m))

(cl:ensure-generic-function 'reserved1-val :lambda-list '(m))
(cl:defmethod reserved1-val ((m <HNR_PVT>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ins_interface-msg:reserved1-val is deprecated.  Use ins_interface-msg:reserved1 instead.")
  (reserved1 m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<HNR_PVT>)))
    "Constants for message type '<HNR_PVT>"
  '((:CLASS_ID . 40)
    (:MESSAGE_ID . 0)
    (:FIX_TYPE_NO_FIX . 0)
    (:FIX_TYPE_DEAD_RECKONING_ONLY . 1)
    (:FIX_TYPE_2D . 2)
    (:FIX_TYPE_3D . 3)
    (:FIX_TYPE_GPS_DEAD_RECKONING_COMBINED . 4)
    (:FIX_TYPE_TIME_ONLY . 5))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'HNR_PVT)))
    "Constants for message type 'HNR_PVT"
  '((:CLASS_ID . 40)
    (:MESSAGE_ID . 0)
    (:FIX_TYPE_NO_FIX . 0)
    (:FIX_TYPE_DEAD_RECKONING_ONLY . 1)
    (:FIX_TYPE_2D . 2)
    (:FIX_TYPE_3D . 3)
    (:FIX_TYPE_GPS_DEAD_RECKONING_COMBINED . 4)
    (:FIX_TYPE_TIME_ONLY . 5))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <HNR_PVT>) ostream)
  "Serializes a message object of type '<HNR_PVT>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'year)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'year)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'month)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'day)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'hour)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'min)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'sec)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'valid)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'VALID_DATE)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'VALID_TIME)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'VALID_FULLY_RESOLVED)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'VALID_MAG)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'nano)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'gpsFix)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'flags)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_GNSS_FIX_OK)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_DIFF_SOLN)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_WKN_SET)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_TOW_SET)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_HEAD_VEH_VALID)) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream))
   (cl:slot-value msg 'reserved0))
  (cl:let* ((signed (cl:slot-value msg 'lon)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'lat)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'height)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'hMSL)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'gSpeed)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'speed)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'headMot)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'headVeh)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'hAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'hAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'hAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'hAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'vAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'vAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'vAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'vAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'sAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'sAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'sAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'sAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'headAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'headAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'headAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'headAcc)) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream))
   (cl:slot-value msg 'reserved1))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <HNR_PVT>) istream)
  "Deserializes a message object of type '<HNR_PVT>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'year)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'year)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'month)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'day)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'hour)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'min)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'sec)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'valid)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'VALID_DATE)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'VALID_TIME)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'VALID_FULLY_RESOLVED)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'VALID_MAG)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'nano) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'gpsFix)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'flags)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_GNSS_FIX_OK)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_DIFF_SOLN)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_WKN_SET)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_TOW_SET)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'FLAGS_HEAD_VEH_VALID)) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'reserved0) (cl:make-array 2))
  (cl:let ((vals (cl:slot-value msg 'reserved0)))
    (cl:dotimes (i 2)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'lon) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'lat) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'height) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'hMSL) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'gSpeed) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'speed) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'headMot) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'headVeh) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'hAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'hAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'hAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'hAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'vAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'vAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'vAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'vAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'sAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'sAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'sAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'sAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'headAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'headAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'headAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'headAcc)) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'reserved1) (cl:make-array 4))
  (cl:let ((vals (cl:slot-value msg 'reserved1)))
    (cl:dotimes (i 4)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<HNR_PVT>)))
  "Returns string type for a message object of type '<HNR_PVT>"
  "ins_interface/HNR_PVT")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'HNR_PVT)))
  "Returns string type for a message object of type 'HNR_PVT"
  "ins_interface/HNR_PVT")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<HNR_PVT>)))
  "Returns md5sum for a message object of type '<HNR_PVT>"
  "d33eab200001ff2d862a768edf2ace25")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'HNR_PVT)))
  "Returns md5sum for a message object of type 'HNR_PVT"
  "d33eab200001ff2d862a768edf2ace25")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<HNR_PVT>)))
  "Returns full string definition for message of type '<HNR_PVT>"
  (cl:format cl:nil "# HNR-PVT (0x28 0x00)~%# High Rate Output of PVT Solution~%#~%# Note that during a leap second there may be more (or less) than 60 seconds in~%# a minute; see the description of leap seconds for details.~%#~%# This message provides the position, velocity and time solution with high ~%# output rate.~%#~%# Supported on ADR and UDR products.~%#~%std_msgs/Header header~%~%uint8 CLASS_ID = 40~%uint8 MESSAGE_ID = 0~%~%uint32 iTOW             # GPS Millisecond time of week [ms]~%uint16 year             # Year (UTC)~%uint8 month             # Month, range 1..12 (UTC)~%uint8 day               # Day of month, range 1..31 (UTC)~%uint8 hour              # Hour of day, range 0..23 (UTC)~%uint8 min               # Minute of hour, range 0..59 (UTC)~%uint8 sec               # Seconds of minute, range 0..60 (UTC)~%~%uint8 valid             # Validity flags~%uint8 VALID_DATE            # Valid UTC Date~%uint8 VALID_TIME            # Valid ~%uint8 VALID_FULLY_RESOLVED  # UTC time of day has been fully resolved ~%                                # (no seconds uncertainty)~%uint8 VALID_MAG             # Valid Magnetic Declination~%~%int32 nano              # fraction of a second [ns], range -1e9 .. 1e9 (UTC)~%~%uint8 gpsFix            # GPS fix Type, range 0..5~%uint8 FIX_TYPE_NO_FIX = 0~%uint8 FIX_TYPE_DEAD_RECKONING_ONLY = 1~%uint8 FIX_TYPE_2D = 2                           # Signal from only 3 SVs, ~%                                                # constant altitude assumed~%uint8 FIX_TYPE_3D = 3~%uint8 FIX_TYPE_GPS_DEAD_RECKONING_COMBINED = 4  # GPS + Dead reckoning~%uint8 FIX_TYPE_TIME_ONLY = 5                    # Time only fix ~%~%uint8 flags             # Fix Status Flags~%uint8 FLAGS_GNSS_FIX_OK          # i.e. within DOP & accuracy masks~%uint8 FLAGS_DIFF_SOLN            # DGPS used~%uint8 FLAGS_WKN_SET              # Valid GPS week number~%uint8 FLAGS_TOW_SET              # Valid GPS time of week (iTOW & fTOW)~%uint8 FLAGS_HEAD_VEH_VALID      # heading of vehicle is valid~%~%uint8[2] reserved0      # Reserved~%~%int32 lon               # Longitude [deg / 1e-7]~%int32 lat               # Latitude [deg / 1e-7]~%int32 height            # Height above Ellipsoid [mm]~%int32 hMSL              # Height above mean sea level [mm]~%~%int32 gSpeed            # Ground Speed (2-D) [mm/s]~%int32 speed             # Speed (3-D) [mm/s]~%~%int32 headMot           # Heading of motion (2-D) [deg / 1e-5]~%int32 headVeh           # Heading of vehicle (2-D) [deg / 1e-5]~%~%uint32 hAcc             # Horizontal Accuracy Estimate [mm]~%uint32 vAcc             # Vertical Accuracy Estimate [mm]~%uint32 sAcc             # Speed Accuracy Estimate [mm/s]~%uint32 headAcc          # Heading Accuracy Estimate (both motion & vehicle) ~%                        # [deg / 1e-5]~%~%uint8[4] reserved1      # Reserved~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'HNR_PVT)))
  "Returns full string definition for message of type 'HNR_PVT"
  (cl:format cl:nil "# HNR-PVT (0x28 0x00)~%# High Rate Output of PVT Solution~%#~%# Note that during a leap second there may be more (or less) than 60 seconds in~%# a minute; see the description of leap seconds for details.~%#~%# This message provides the position, velocity and time solution with high ~%# output rate.~%#~%# Supported on ADR and UDR products.~%#~%std_msgs/Header header~%~%uint8 CLASS_ID = 40~%uint8 MESSAGE_ID = 0~%~%uint32 iTOW             # GPS Millisecond time of week [ms]~%uint16 year             # Year (UTC)~%uint8 month             # Month, range 1..12 (UTC)~%uint8 day               # Day of month, range 1..31 (UTC)~%uint8 hour              # Hour of day, range 0..23 (UTC)~%uint8 min               # Minute of hour, range 0..59 (UTC)~%uint8 sec               # Seconds of minute, range 0..60 (UTC)~%~%uint8 valid             # Validity flags~%uint8 VALID_DATE            # Valid UTC Date~%uint8 VALID_TIME            # Valid ~%uint8 VALID_FULLY_RESOLVED  # UTC time of day has been fully resolved ~%                                # (no seconds uncertainty)~%uint8 VALID_MAG             # Valid Magnetic Declination~%~%int32 nano              # fraction of a second [ns], range -1e9 .. 1e9 (UTC)~%~%uint8 gpsFix            # GPS fix Type, range 0..5~%uint8 FIX_TYPE_NO_FIX = 0~%uint8 FIX_TYPE_DEAD_RECKONING_ONLY = 1~%uint8 FIX_TYPE_2D = 2                           # Signal from only 3 SVs, ~%                                                # constant altitude assumed~%uint8 FIX_TYPE_3D = 3~%uint8 FIX_TYPE_GPS_DEAD_RECKONING_COMBINED = 4  # GPS + Dead reckoning~%uint8 FIX_TYPE_TIME_ONLY = 5                    # Time only fix ~%~%uint8 flags             # Fix Status Flags~%uint8 FLAGS_GNSS_FIX_OK          # i.e. within DOP & accuracy masks~%uint8 FLAGS_DIFF_SOLN            # DGPS used~%uint8 FLAGS_WKN_SET              # Valid GPS week number~%uint8 FLAGS_TOW_SET              # Valid GPS time of week (iTOW & fTOW)~%uint8 FLAGS_HEAD_VEH_VALID      # heading of vehicle is valid~%~%uint8[2] reserved0      # Reserved~%~%int32 lon               # Longitude [deg / 1e-7]~%int32 lat               # Latitude [deg / 1e-7]~%int32 height            # Height above Ellipsoid [mm]~%int32 hMSL              # Height above mean sea level [mm]~%~%int32 gSpeed            # Ground Speed (2-D) [mm/s]~%int32 speed             # Speed (3-D) [mm/s]~%~%int32 headMot           # Heading of motion (2-D) [deg / 1e-5]~%int32 headVeh           # Heading of vehicle (2-D) [deg / 1e-5]~%~%uint32 hAcc             # Horizontal Accuracy Estimate [mm]~%uint32 vAcc             # Vertical Accuracy Estimate [mm]~%uint32 sAcc             # Speed Accuracy Estimate [mm/s]~%uint32 headAcc          # Heading Accuracy Estimate (both motion & vehicle) ~%                        # [deg / 1e-5]~%~%uint8[4] reserved1      # Reserved~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <HNR_PVT>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4
     2
     1
     1
     1
     1
     1
     1
     1
     1
     1
     1
     4
     1
     1
     1
     1
     1
     1
     1
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'reserved0) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
     4
     4
     4
     4
     4
     4
     4
     4
     4
     4
     4
     4
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'reserved1) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <HNR_PVT>))
  "Converts a ROS message object to a list"
  (cl:list 'HNR_PVT
    (cl:cons ':header (header msg))
    (cl:cons ':iTOW (iTOW msg))
    (cl:cons ':year (year msg))
    (cl:cons ':month (month msg))
    (cl:cons ':day (day msg))
    (cl:cons ':hour (hour msg))
    (cl:cons ':min (min msg))
    (cl:cons ':sec (sec msg))
    (cl:cons ':valid (valid msg))
    (cl:cons ':VALID_DATE (VALID_DATE msg))
    (cl:cons ':VALID_TIME (VALID_TIME msg))
    (cl:cons ':VALID_FULLY_RESOLVED (VALID_FULLY_RESOLVED msg))
    (cl:cons ':VALID_MAG (VALID_MAG msg))
    (cl:cons ':nano (nano msg))
    (cl:cons ':gpsFix (gpsFix msg))
    (cl:cons ':flags (flags msg))
    (cl:cons ':FLAGS_GNSS_FIX_OK (FLAGS_GNSS_FIX_OK msg))
    (cl:cons ':FLAGS_DIFF_SOLN (FLAGS_DIFF_SOLN msg))
    (cl:cons ':FLAGS_WKN_SET (FLAGS_WKN_SET msg))
    (cl:cons ':FLAGS_TOW_SET (FLAGS_TOW_SET msg))
    (cl:cons ':FLAGS_HEAD_VEH_VALID (FLAGS_HEAD_VEH_VALID msg))
    (cl:cons ':reserved0 (reserved0 msg))
    (cl:cons ':lon (lon msg))
    (cl:cons ':lat (lat msg))
    (cl:cons ':height (height msg))
    (cl:cons ':hMSL (hMSL msg))
    (cl:cons ':gSpeed (gSpeed msg))
    (cl:cons ':speed (speed msg))
    (cl:cons ':headMot (headMot msg))
    (cl:cons ':headVeh (headVeh msg))
    (cl:cons ':hAcc (hAcc msg))
    (cl:cons ':vAcc (vAcc msg))
    (cl:cons ':sAcc (sAcc msg))
    (cl:cons ':headAcc (headAcc msg))
    (cl:cons ':reserved1 (reserved1 msg))
))
