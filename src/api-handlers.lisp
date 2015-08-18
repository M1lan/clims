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


;;TODO: Have json-rpc return a everything worked message on completion
;;TODO: Have json-rpc return an error message when an error is thrown
;; method: sale
(json-rpc::defun-json-rpc sale :guessing (materials buyer)
  (handle-sale (cdr materials) (cdr buyer)))

;;method: order
(json-rpc::defun-json-rpc order :guessing (materials supplier)
  (handle-order (cdr materials) (cdr supplier)))

;;method: manufacturing
(json-rpc::defun-json-rpc manufacturing :guessing (outputs inputs batch-name)
  (handle-manufacturing (cdr outputs) (cdr inputs) (cdr batch-name)))

;;method get-data
(prog1
    (json-rpc::def-json-rpc-encoding :view-data (raw-val)
      (list :json
       (json:encode-json-alist-to-string raw-val))))

(json-rpc::defun-json-rpc views :view-data (view-name)
  (log:error "enter getData" view-name)
  (let ((name (cdr view-name)))
    (cond
      ((string= name "manufacturing") (manufacturing-view-data))
      ((string= name "sales") (sale-view-data))
      ((string= name "orders") (order-view-data))
      (t nil))))
