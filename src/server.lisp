(in-package :clims)

(defvar *api-server* nil)

(defun file-string (path)
  (with-open-file (stream path)
    (let ((data (make-string (file-length stream))))
      (read-sequence data stream)
      data)))

(defun authenticate (username password)
  (and
   (string= username "gaige@a.com")
   (string= password "pass")))

(defun generate-shared-secret ()
  (cl-base64:integer-to-base64-string (random (* 10 10))))

(define-easy-handler (index :uri "/") ()
  (when (session-value :logged-in-p *session*)
    (redirect "/safe"))
  (with-html-output-to-string (out)
    (:html
     (:head
      (:meta :lisp "awesome")
      (:meta :charset "UTF-8"))
     (:body
      ;; Start of login form
      (:form :action "/login" :method "POST"
             (:div :class "form-group"
                   (:label :for "user-email" "Email Address")
                   (:input :name "user-email" :type "email" :placeholder "Email"))
             (:div :class "form-group"
                   (:label :for "user-password" "Password")
                   (:input :name "user-password" :type "password" :placeholder "Password"))
             (:div :class "form-group"
                   (:label
                    (:input :name "remember-me-p" :type "checkbox" "Remember?")))
             (:button :type "submit" :class "btn btn-default" "Submit"))
      (:script :src "http://crypto-js.googlecode.com/svn/tags/3.1.2/build/rollups/sha256.js")
      (:script "var hash = CryptoJS.SHA256('Message');")))))

(define-easy-handler (login :uri "/login") ()
  ;; Look into the below link for a protocol (in headers) level way of sending credentials
  ;; http://www.httpwatch.com/httpgallery/authentication/
  (let ((username (post-parameter "user-email"))
        (password (post-parameter "user-password")))
    (hunchentoot:log-message* :info "user-email -> ~a ~% user-password -> ~a" username password)
    (if (authenticate username password)
        (progn
          ;;(setf (hunchentoot:content-type*) "text/html")
          (let ((session (start-session))
                (shared-secret (generate-shared-secret)))
            ;; Set the shared secret for the session
            (setf (session-value :username session) username)
            (setf (session-value :secret session) shared-secret)
            (setf (session-value :logged-in-p session) t)
            ;; this val below gets returned on success, the shared secret
            (redirect "/api")))
        ;; instead of abort, should redirect or notify of wrong credentials
        (redirect "/"))))

(define-easy-handler (logout :uri "/logout") ()
  ;; TODO: Figure out how to refer to \the\ session in the context of a request
  ;; Then I can move on to preventing dup sessions
  ;; SOLVED: *session* gets the session for a handler's request context
  (when *session*
    (remove-session *session*))
  (redirect "/"))

(define-easy-handler (app :uri "/static/app.js") ()
  (file-string "/home/gaige/lisp/clims/static/app.js"))

(define-easy-handler (api :uri "/api") ()
  (when (session-value :logged-in-p)
    (with-html-output-to-string (out)
      (:html
       (:head
        (:meta :lisp "awesome")
        (:meta :charset "UTF-8"))
       (:body
        (:div :id "messanger"
              (:code :id "json" "{}"))
        (:button :type "button" :onclick "request()" "try!")
        (:script :src "/static/app.js")
        (:script :src "http://crypto-js.googlecode.com/svn/tags/3.1.2/build/rollups/sha256.js"))))))

(define-easy-handler (p :uri "/p") ()
  (when (session-value :logged-in-p)
    (format nil "{some: '~a', id: ~a}" (session-value :secret) (random 100))))

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
         :access-log-destination "clims-access.log"
         :message-log-destination "clims-error.log"))
  (hunchentoot:start *api-server*))

(defun stop-server ()
  (when *api-server*
    (stop *api-server* :soft t)))
