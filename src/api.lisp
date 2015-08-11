(in-package :clims)

(defun generate-shared-secret ()
  "secret")

(json-rpc::def-json-rpc-encoding :echo (raw-val)
  (list :json
	(json:encode-json-to-string
	 `((:text . ,raw-val)))))

(json-rpc::defun-json-rpc echo :guessing (text)
  (log:debug "in echo for ~A" text)
  ;; (unless (stringp text)
  ;;   (invoke-restart
  ;;    'json-rpc::send-error
  ;;    (format nil "JSON handler error! Input: '~A' should be a string" text) 99))
  (log:info (cdr text))
  (cdr text))

(json-rpc::defun-json-rpc table :guessing (table-name)
  (log:error "ASD" table-name))

(json-rpc::defun-json-rpc authenticate :guessing (username password)
  (log:info "In authenticate ~a ~a" (cdr username) (cdr password))
  ;; TODO: Lookup user with username.
  ;;       With user's salt, determine if password is correct.
  ;;       create session, generate shared-secret for hmac, etc
  (let* ((user-salt "super-random")
	 (user-hashed-password "mMAzwqGbJGxkaRDT9ZojKv5yqllCW54nrk+aoveorrk=")
	 (password (cdr password))
	 (digester (ironclad:make-digest :sha256))
	 (hashed-result (progn
			  (ironclad:update-digest digester (sb-ext:string-to-octets password))
			  (ironclad:update-digest digester (sb-ext:string-to-octets user-salt))
			  (with-output-to-string (out)
			    (s-base64:encode-base64-bytes
			     (ironclad:produce-digest digester) out nil)))))
    (unless (string= hashed-result user-hashed-password)
      (invoke-restart
       'json-rpc::send-error
       (format nil "failed to authenticate user ~A." (cdr username))))
    ;; upon success return a new shared-secret
    (generate-shared-secret)))

(defun json-rpc-handler ()
  (let ((json-source (flexi-streams:octets-to-string (raw-post-data)))
	(signiture (hunchentoot:header-in* :signiture)))
    (json-bind (method params id) json-source
      (if (not (and method params id signiture (session-value :logged-in-p)))
	  (progn
	    (log:error method params id signiture
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
	     (log:info method id params signiture)
	     (json-rpc::invoke-rpc-parsed method params id))))))

(defun sign-request (method json-params shared-secret)
  (log:warn json-params)
  (let ((hmac (ironclad:make-hmac (sb-ext:string-to-octets shared-secret)
                                  'ironclad:SHA1)))
    (ironclad:update-hmac hmac (sb-ext:string-to-octets method))
    (ironclad:update-hmac hmac (sb-ext:string-to-octets shared-secret))
    (ironclad:update-hmac hmac (sb-ext:string-to-octets json-params))
    (with-output-to-string (out)
      (s-base64:encode-base64-bytes (ironclad:hmac-digest hmac) out nil))))
