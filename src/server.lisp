(in-package :clims)

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

(defun generate-shared-secret ()
  (cl-base64:integer-to-base64-string (random (* 10 10))))


(define-easy-handler (index :uri "/") ()
  (file-string #p"./static/login.html"))

(define-easy-handler (safe :uri "/safe") ()
  (if (session-value :logged-in-p)
      (format nil "Logged in!: ~a" (session-value :logged-in-p))
      (format nil "~a : ~a"
              (session-value :secret)
              (session-value :logged-in-p))))

(define-easy-handler (login :uri "/login") ()
  ;; Look into the below link for a protocol (in headers) level way of sending credentials
  ;; http://www.httpwatch.com/httpgallery/authentication/
  (let ((username (post-parameter "username"))
        (password (post-parameter "password")))
    (if (authenticate username password)
        (progn
          ;;(setf (hunchentoot:content-type*) "text/html")
          (let ((session (start-session))
                (shared-secret (generate-shared-secret)))
            ;; Set the shared secret for the session
            (setf (session-value :secret session) shared-secret)
            (setf (session-value :logged-in-p session) t))
          (abort-request-handler)))))

(define-easy-handler (logout :uri "/logout") ()
  ;; TODO: Figure out how to refer to \the\ session in the context of a request
  ;; Then I can move on to preventing dup sessions

  ;; Session removal seems to require an identifier for which session. It doesn't remove the active one.

  ;; Should this completely log the user out?
  ;; Should there be a way to refresh/kill your api key without logging out?
  )

(defun start-server ()
  (setq hunchentoot:*session-max-time* (* 10 60) ;; 1 minute
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
