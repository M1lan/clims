(defvar *api-server* nil)

(defun file-string (path)
  (with-open-file (stream path)
    (let ((data (make-string (file-length stream))))
      (read-sequence data stream)
            data)))

(defun authenticate (username password)
  (declare (ignore username password))
  t
  )

(define-easy-handler (index :uri "/") ()
  (file-string #p"./login.html"))

(define-easy-handler (safe :uri "/safe") ()
  (session-value 'secret))

(define-easy-handler (login :uri "/login") ()
  (let ((username (post-parameter "username"))
        (password (post-parameter "password")))
    (when (authenticate username password)
      ;; Make sure to prevent duplicate session
      (start-session)
      ;; When the user has been authenticated:
      ;; redirect them (where ?)
      ;; AND
      ;; return a shared secret for use with HMAC for the life of the session
      (let ((shared-secret (cl-base64:integer-to-base64-string (random (* 10 10)))))
        ;; Fill in the html to be returned.
        ;; My idea so far is that the secret will be rendered into the "main" of the JS or something like that

        ;;(setf (hunchentoot:content-type*) "text/html")
        (setf (session-value :secret) shared-secret)
        (format nil "~a" (session-value :secret))))))

(define-easy-handler (logout :uri "/logout") ()
  ;; TODO: Figure out how to refer to \the\ session in the context of a request
  ;; Then I can move on to preventing dup sessions

  ;; Session removal seems to require an identifier for which session. It doesn't remove the active one.

  ;; Should this completely log the user out?
  ;; Should there be a way to refresh/kill your api key without logging out?
  )

(defun start-server ()
  (setq hunchentoot:*session-max-time* (* 1 60) ;; 1 minute
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
         :access-log-destination "clims-access.log"
         :message-log-destination "clims-error.log"))
  (hunchentoot:start *api-server*))

(defun stop-server ()
  (when *api-server*
    (stop *api-server* :soft t)))
