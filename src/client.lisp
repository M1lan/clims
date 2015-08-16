(ql:quickload :drakma)
(ql:quickload :cl-json)
(ql:quickload :s-base64)
(ql:quickload :ironclad)

(defun sign-request (method json-params shared-secret)
  (log:debug json-params shared-secret)
  (let ((hmac (ironclad:make-hmac (sb-ext:string-to-octets shared-secret)
                                  'ironclad:SHA256)))
    (ironclad:update-hmac hmac (sb-ext:string-to-octets method))
    (ironclad:update-hmac hmac (sb-ext:string-to-octets json-params))
    (with-output-to-string (out)
      (s-base64:encode-base64-bytes (ironclad:hmac-digest hmac) out nil))))

(defun api-request (method params)
  (log:error (json:encode-json-to-string (cdr (assoc "params" params :test 'string=))))
  (let* ((cookie-jar (make-instance 'drakma:cookie-jar))
	 (shared-secret (progn 
			  (drakma:http-request "http://localhost:8000/login"
					       :method :post
					       :content-type "text/json"
					       :parameters  '(("username" . "admint@test.com")
							      ("password" . "pass"))
					       :cookie-jar cookie-jar)
			  (drakma:http-request "http://localhost:8000/key"
					       :method :get
					       :cookie-jar cookie-jar)))
	 (json-params (json:encode-json-to-string params))
	 (digest (sign-request
		  method
		  (json:encode-json-to-string (cdr (assoc "params" params :test 'string=)) )
		  shared-secret)))
    (log:info shared-secret digest json-params)
    (drakma:http-request "http://localhost:8000/_api"
			 :method :post
			 :additional-headers `(("signiture" . ,digest))
			 :content-type "text/json"
			 :content json-params
			 :cookie-jar cookie-jar)))
