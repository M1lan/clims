(defun api-request (method)
  (let* ((cookie-jar (make-instance 'drakma:cookie-jar))
	 (shared-secret "secret")
	 (hmac (ironclad:make-hmac (sb-ext:string-to-octets shared-secret) 'ironclad:SHA1))
	 (message "{\"text\":\"hello\"}")
	 (digest (progn
		   (ironclad:update-hmac hmac (sb-ext:string-to-octets method))
		   (ironclad:update-hmac hmac (sb-ext:string-to-octets shared-secret))
		   (ironclad:update-hmac hmac (sb-ext:string-to-octets message))
		   (with-output-to-string (out)
		     (s-base64:encode-base64-bytes (ironclad:hmac-digest hmac) out nil)))))
    ;; get a cookie
    (drakma:http-request "http://localhost:8000/login"
			 :method :post
			 :basic-authorization '("admin@test.com" "pass")
			 :parameters '(("username" . "admin@test.com")
				       ("password" . "pass"))
			 :cookie-jar cookie-jar)
    ;; make api request
    (log:info (drakma:http-request "http://localhost:8000/_api"
				   :method :post
				   :content-type "application/json"
				   :additional-headers `((:signiture ,digest))
				   :content (json:encode-json-to-string `(("method" . ,method)
									  ("params"  ("text" . "hello"))
									  ("id" . 1)
									  ("jsonrpc" . "2.0")))
				   :cookie-jar cookie-jar))
    ; what was the signiture we sent
    (log:info "~A" digest)))
