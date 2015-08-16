(in-package :clims)

(defun json-rpc-handler ()
  (let ((json-source (flexi-streams:octets-to-string (raw-post-data)))
	(signiture (hunchentoot:header-in* :signiture)))
    (json-bind (method params id) json-source
      (if (not (and method params id signiture (session-value :logged-in-p *session*)))
	  (progn
	    (log:error method params id signiture (session-value :logged-in-p)
		       "Invalid parameters.")
	    (setf (hunchentoot:content-type* hunchentoot::*reply*)
		  "text/json")
	    (json:encode-json-to-string
	     `(("result" . nil)
	       ("error"
		("code" . 999)
		("message" . "An error occured")
		("data"
		 ("app" . "ims_api")
		 ("code" . "invalid_parameters")))
	       ("id" . ,id))))
	  (handler-case
	      (progn
		(setf (hunchentoot:content-type* hunchentoot::*reply*)
		  "text/json")
		(let ((json-params (json:encode-json-to-string params)))
		  (invoke-auth-rpc method json-params id (session-value :shared-secret) signiture)))
	    (error (c)
	      (log:error method id signiture
			 (format nil "unknown_error: ~A" c))
	      (setf (hunchentoot:content-type* hunchentoot::*reply*)
		    "text/json")
	      (json:encode-json-to-string
	       `(("result" . nil)
		 ("error"
		  ("code" . 998)
		  ("message" . "An error occurred.")
		  ("data"
		   ("app" . "ims_api")
		   ("message" . ,(format nil "~A" c))
		   ("code" . "unknown_error")))
		 ("id" . ,id)))))))))

(defun invoke-auth-rpc (method json-params id shared-secret signiture)
  (let ((signiture (remove #\( (remove #\) signiture))))
    (cond ((not (equal signiture
		       (sign-request method json-params shared-secret)))
	   (log:error "failed to verify message." method json-params signiture)
	   (json:encode-json-to-string
	    `(("result" . nil)
	      ("error"
	       ("code" . 1)
	       ("message" . "an error occured")
	       ("data" ("app" . "ims_api" )
		       ("code" . "failed_message_verification")))
	      ("id" . ,id))))
	  (t
	   ;; call invoke-rpc-parsed
	   (let ((params (json:decode-json-from-string json-params)))
	     (json-rpc::invoke-rpc-parsed method params id))))))

(defun sign-request (method json-params shared-secret)
  (let ((hmac (ironclad:make-hmac (sb-ext:string-to-octets shared-secret)
				  'ironclad:SHA256)))
    (ironclad:update-hmac hmac (sb-ext:string-to-octets method))
    (ironclad:update-hmac hmac (sb-ext:string-to-octets json-params))
    (with-output-to-string (out)
      (s-base64:encode-base64-bytes (ironclad:hmac-digest hmac) out nil))))
