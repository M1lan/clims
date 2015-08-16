(in-package :clims)

;; method: echo
(prog1
    (json-rpc::def-json-rpc-encoding :echo (raw-val)
      (list :json
	    (json:encode-json-to-string
	     `((:text . ,raw-val))))))

(json-rpc::defun-json-rpc echo :echo (text)
  ;; (unless (stringp text)
  ;;   (invoke-restart
  ;;    'json-rpc::send-error
  ;;    (format nil "JSON handler error! Input: '~A' should be a string" text) 99))
  (log:info (cdr text))
  (cdr text))

;; method: table
(prog1 
    (json-rpc::def-json-rpc-encoding :table (raw-val)
      (list :json
	    (json:encode-json-alist-to-string ; try encode-json-alist-to-string	 
	     raw-val))))

(json-rpc::defun-json-rpc table :table (name)
  (table-as-list (cdr name)))

;; method:
