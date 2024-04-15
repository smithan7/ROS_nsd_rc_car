
(cl:in-package :asdf)

(defsystem "ins_interface-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "HNR_PVT" :depends-on ("_package_HNR_PVT"))
    (:file "_package_HNR_PVT" :depends-on ("_package"))
  ))