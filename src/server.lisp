(in-package :clims)

(defvar *api-server* nil)

(defun auth (username password)
  t)
  (and
   (string= username "admin@test.com")
   (string= password "pass")))

(define-easy-handler (login :uri "/login") ()
  (let ((username (post-parameter "username"))
        (password (post-parameter "password")))
    (log:info username password)
    (if (auth username password)
	(let ((shared-secret "secret"))
	  (setf (session-value :shared-secret *session*) shared-secret)
	  (setf (session-value :username *session*) username)
	  (setf (session-value :logged-in-p *session*) t)
	  ;; The share secret needs to be returned
	  (setf (hunchentoot:content-type*) "text/plain")
 	  (log:info "authed!" shared-secret (session-value :logged-in-p))
	  shared-secret)
	;; or they get nothing!
	nil)))

(define-easy-handler (logout :uri "/logout") ()
  (when *session*
    (remove-session *session*))
  (redirect "/"))

(define-easy-handler (api :uri "/api") ()
  (setf (content-type*) "text/json")
  (let ((data (json:decode-json-from-string (flexi-streams:octets-to-string (raw-post-data)))))
    (declare (ignore data))
    (invoke-rpc (flexi-streams:octets-to-string (raw-post-data)))))

(defun start-server ()
  (setq hunchentoot:*session-max-time* (* 10 60) ;; 10 minute
        hunchentoot:*CATCH-ERRORS-P* t
        hunchentoot:*log-lisp-errors-p* t
        hunchentoot:*log-lisp-backtraces-p* t
        hunchentoot:*log-lisp-warnings-p* t
        hunchentoot:*lisp-errors-log-level* :debug
        hunchentoot:*lisp-warnings-log-level* :debug)
  (setq *api-server*
        (make-instance
         'hunchentoot:easy-acceptor
         :port 8000
	 :document-root #p"/home/gaige/lisp/clims/static/"
         :access-log-destination "clims-access.log"
         :message-log-destination "clims-error.log"))
  (push (hunchentoot:create-prefix-dispatcher
         "/_api" 'json-rpc-handler)
        hunchentoot:*dispatch-table*)
  (hunchentoot:start *api-server*))

(defun stop-server ()
  (when *api-server*
    (stop *api-server* :soft t)))

(defun restart-server ()
  (stop-server)
  (log:info "Restartin server...")
  (start-server))
