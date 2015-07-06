;;;; clims.asd
(defpackage :clims-system (:use :cl :asdf))
(in-package :clims-system)

(defsystem :clims
  :name "clims"
  :version "0.1.0"
  :description "An inventory managment system."
  :author "Gaige Pierce-Raison <first name at chatsubo dot net>"
  :license "MIT"
  :depends-on (:hunchentoot
               :cl-who
               :parenscript)
  :components ((:file "package")))