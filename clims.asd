(asdf:defsystem :clims
  :author "Gaige Pierce-Raison, Eric Clark"
  :license "MIT"
  :version "0.1.0"
  :name "clims"
  :description "An inventory managment system."
  :depends-on (#:cl-json
               #:cl-who
               #:hunchentoot
	       #:ironclad
	       #:log4cl
	       #:postmodern
	       #:s-base64
               )
  :components ((:file "package")
               (:file "src/server" :depends-on ("package"))
	       (:file "src/api" :depends-on ("src/server"))
	       (:file "src/queries" :depends-on ("src/server"))))
