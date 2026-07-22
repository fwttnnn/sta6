(defpackage #:sta6
  (:use #:cl)
  (:export #:spit
           #:walk
           #:render
           #:build
           #:html
           #:html5))

(defun sta6:spit (path fn &rest args)
  (ensure-directories-exist path)
  (with-open-file (out path :direction :output
                            :if-exists :supersede
                            :if-does-not-exist :create)
    (let ((*standard-output* out))
      (apply fn args))))
  
(defun sta6:walk (dir)
  (append
    (uiop:directory-files dir)
    (mapcan #'sta6:walk
            (uiop:subdirectories dir))))

(defun sta6:render (args)
  ())

(defun sta6:build ()
  (let ((root (uiop:ensure-directory-pathname (truename "src/pages/"))))
    (flet ((extract-package-name (filepath)
             (let* ((file-dirs (rest (pathname-directory filepath)))
                    (base-dirs (rest (pathname-directory root)))
                    (dirs      (nthcdr (length base-dirs) file-dirs)))
               (format nil "~{~a/~}~a"
                           dirs
                           (pathname-name filepath))))
           (dynamic-route-p (route)
             (some (lambda (slug)
                     (and (>= (length slug) 3)
                           (char= (char slug 0) #\+)
                           (char= (char slug (1- (length slug))) #\+)))
                   (uiop:split-string route :separator "/"))))
      (labels ((render (dir args)
                 (dolist (filepath (uiop:directory-files dir))
                   (let* ((pkg-name (extract-package-name filepath))
                          (pkg (find-package (string-upcase (concatenate 'string "pages/" pkg-name))))
                          (dirs (uiop:split-string pkg-name :separator "/"))
                          (filename (car (last dirs)))
                          (output-path (cond ((string= filename "404")  (make-pathname :directory '(:relative "build") :name "404" :type "html"))
                                             ((string= filename "page") (make-pathname :directory `(:relative "build" ,@(butlast dirs)) :name "index" :type "html"))
                                             (t                         (make-pathname :directory `(:relative "build" ,@(butlast dirs) ,filename) :name "index" :type "html"))))
                          (symbol-routes (find-symbol "ROUTES" pkg))
                          (symbol-render (find-symbol "RENDER" pkg)))
                     (if symbol-routes
                         (dolist (route (apply (symbol-function symbol-routes) args))
                           (apply #'sta6:spit
                                  (make-pathname :directory `(:relative "build" ,@(butlast dirs) ,(princ-to-string route)) :name "index" :type "html")
                                  (symbol-function symbol-render)
                                  (append args (list route))))
                         (apply #'sta6:spit
                                output-path
                                (symbol-function symbol-render)
                                args))))
                 (dolist (child (uiop:subdirectories dir))
                   (render child args))))
        (render root '())))))

(defmacro sta6:html (&rest tags)
  `(spinneret:with-html
     ,@tags))

(defmacro sta6:html5 (&rest tags)
  (let ((head '())
        (body '()))
    (dolist (tag tags)
      (cond
        ((and (consp tag) (eq (first tag) :head)) (setf head (rest tag)))
        (t                                        (push tag body))))
    `(let ((spinneret:*suppress-inserted-spaces* t)
           (spinneret:*html-style* :tree)
           (*print-pretty* nil))
       (format t "<!DOCTYPE html>~%")
       (format t "~a~%"
               (spinneret:with-html-string
                 (:html
                  (:head ,@head)
                  (:body ,@(nreverse body))))))))
