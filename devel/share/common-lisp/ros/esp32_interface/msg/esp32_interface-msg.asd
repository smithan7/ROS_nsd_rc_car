
(cl:in-package :asdf)

(defsystem "esp32_interface-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "Car_Control" :depends-on ("_package_Car_Control"))
    (:file "_package_Car_Control" :depends-on ("_package"))
    (:file "Driveshaft_Encoder" :depends-on ("_package_Driveshaft_Encoder"))
    (:file "_package_Driveshaft_Encoder" :depends-on ("_package"))
    (:file "PWM_Cmd" :depends-on ("_package_PWM_Cmd"))
    (:file "_package_PWM_Cmd" :depends-on ("_package"))
    (:file "PWM_Measure" :depends-on ("_package_PWM_Measure"))
    (:file "_package_PWM_Measure" :depends-on ("_package"))
  ))