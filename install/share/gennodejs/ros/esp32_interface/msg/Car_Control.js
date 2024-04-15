// Auto-generated. Do not edit!

// (in-package esp32_interface.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let std_msgs = _finder('std_msgs');

//-----------------------------------------------------------

class Car_Control {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.header = null;
      this.desired_steering_angle = null;
      this.desired_acceleration = null;
      this.desired_speed = null;
    }
    else {
      if (initObj.hasOwnProperty('header')) {
        this.header = initObj.header
      }
      else {
        this.header = new std_msgs.msg.Header();
      }
      if (initObj.hasOwnProperty('desired_steering_angle')) {
        this.desired_steering_angle = initObj.desired_steering_angle
      }
      else {
        this.desired_steering_angle = 0.0;
      }
      if (initObj.hasOwnProperty('desired_acceleration')) {
        this.desired_acceleration = initObj.desired_acceleration
      }
      else {
        this.desired_acceleration = 0.0;
      }
      if (initObj.hasOwnProperty('desired_speed')) {
        this.desired_speed = initObj.desired_speed
      }
      else {
        this.desired_speed = 0.0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Car_Control
    // Serialize message field [header]
    bufferOffset = std_msgs.msg.Header.serialize(obj.header, buffer, bufferOffset);
    // Serialize message field [desired_steering_angle]
    bufferOffset = _serializer.float32(obj.desired_steering_angle, buffer, bufferOffset);
    // Serialize message field [desired_acceleration]
    bufferOffset = _serializer.float32(obj.desired_acceleration, buffer, bufferOffset);
    // Serialize message field [desired_speed]
    bufferOffset = _serializer.float32(obj.desired_speed, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Car_Control
    let len;
    let data = new Car_Control(null);
    // Deserialize message field [header]
    data.header = std_msgs.msg.Header.deserialize(buffer, bufferOffset);
    // Deserialize message field [desired_steering_angle]
    data.desired_steering_angle = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [desired_acceleration]
    data.desired_acceleration = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [desired_speed]
    data.desired_speed = _deserializer.float32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += std_msgs.msg.Header.getMessageSize(object.header);
    return length + 12;
  }

  static datatype() {
    // Returns string type for a message object
    return 'esp32_interface/Car_Control';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '8f9b642cbe95f516badef7111c9048be';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    std_msgs/Header header
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
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new Car_Control(null);
    if (msg.header !== undefined) {
      resolved.header = std_msgs.msg.Header.Resolve(msg.header)
    }
    else {
      resolved.header = new std_msgs.msg.Header()
    }

    if (msg.desired_steering_angle !== undefined) {
      resolved.desired_steering_angle = msg.desired_steering_angle;
    }
    else {
      resolved.desired_steering_angle = 0.0
    }

    if (msg.desired_acceleration !== undefined) {
      resolved.desired_acceleration = msg.desired_acceleration;
    }
    else {
      resolved.desired_acceleration = 0.0
    }

    if (msg.desired_speed !== undefined) {
      resolved.desired_speed = msg.desired_speed;
    }
    else {
      resolved.desired_speed = 0.0
    }

    return resolved;
    }
};

module.exports = Car_Control;
