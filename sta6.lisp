(defpackage #:sta6
  (:use #:cl)
  (:export #:spit
           #:walk
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

(defun sta6:build ()
  (let ((root (uiop:ensure-directory-pathname (truename "src/pages/"))))
    (flet ((extract-package-name (filepath)
             (let* ((file-dirs (rest (pathname-directory filepath)))
                    (base-dirs (rest (pathname-directory root)))
                    (dirs      (nthcdr (length base-dirs) file-dirs)))
               (format nil "~{~a/~}~a"
                           dirs
                           (pathname-name filepath))))
           (replace-dynamic-route (slugs args)
             (let ((args (copy-list args)))
               (mapcan (lambda (slug)
                         (if (and (>= (length slug) 3)
                                  (char= (char slug 0) #\+)
                                  (char= (char slug (1- (length slug))) #\+))
                             (uiop:split-string (princ-to-string (pop args))
                                                :separator "/")
                             (list slug)))
                       slugs))))
      (labels ((recurse (dir args)
                 (let ((saved-routes nil))
                   ;; NOTE: so that `setf saved-routes` would be called first,
                   ;;       refactor this later.
                   (dolist (filepath (sort (copy-list (uiop:directory-files dir))
                                           (lambda (a b)
                                             (cond ((string= (pathname-name a) "page") t)
                                                   ((string= (pathname-name b) "page") nil)
                                                   (t nil)))))
                     (let* ((pkg-name (extract-package-name filepath))
                            (pkg (find-package (string-upcase (concatenate 'string "pages/" pkg-name))))
                            (dirs (uiop:split-string pkg-name :separator "/"))
                            (filename (car (last dirs)))
                            (symbol-routes (find-symbol "ROUTES" pkg))
                            (symbol-render (find-symbol "RENDER" pkg)))
                       ;; TODO: check if parent is a dynamic slug
                       (if symbol-routes
                           (progn
                             (setf saved-routes (apply (symbol-function symbol-routes) args))
                             (dolist (route saved-routes)
                               (apply #'sta6:spit
                                      (make-pathname :directory `(:relative "build"
                                                                            ,@(replace-dynamic-route
                                                                                (if (string= filename "page")
                                                                                    (butlast dirs)
                                                                                    dirs)
                                                                                (append args (list route))))
                                                                  :name "index"
                                                                  :type "html")
                                      (symbol-function symbol-render)
                                      (append args (list route)))))
                           (if saved-routes
                             (dolist (route saved-routes)
                               (apply #'sta6:spit
                                      (make-pathname :directory `(:relative "build" ,@(replace-dynamic-route (butlast dirs) (append args (list route))) ,filename) :name "index" :type "html")
                                      (symbol-function symbol-render)
                                      (append args (list route))))
                             (apply #'sta6:spit
                                    (cond ((string= filename "404")  (make-pathname :directory '(:relative "build") :name "404" :type "html"))
                                          ((string= filename "page") (make-pathname :directory `(:relative "build" ,@(butlast dirs)) :name "index" :type "html"))
                                          (t                         (make-pathname :directory `(:relative "build" ,@(butlast dirs) ,filename) :name "index" :type "html")))
                                    (symbol-function symbol-render)
                                    args)))))
                   (dolist (sub-dir (uiop:subdirectories dir))
                     (if saved-routes
                         (dolist (route saved-routes)
                           (recurse sub-dir (append args (list route))))
                         (recurse sub-dir args))))))
        (recurse root '())))))

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
