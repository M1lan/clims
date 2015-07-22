(asdf:defsystem :clims
  :author "Gaige Pierce-Raison <first name at chatsubo dot net>"
  :license "MIT"
  :version "0.1.0"
  :name "clims"
  :description "An inventory managment system."
  :depends-on (#:cl-json
               #:cl-who
               #:hunchentoot
               )
  :components ((:file "package")
               (:file "src/server" :depends-on ("package"))))
