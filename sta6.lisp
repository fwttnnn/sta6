(defpackage #:sta6
  (:use #:cl)
  (:export #:spit
           #:walk
           #:render
           #:build
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

(defun sta6:render (pkg-name)
  (let* ((dirs (uiop:split-string pkg-name :separator "/"))
         (file (car (last dirs)))
         (pkg  (find-package (string-upcase (concatenate 'string "pages/" pkg-name))))
         ;; TODO: map dynamic routes
         (out  (cond ((string= file "404")  (make-pathname :directory '(:relative "build") :name "404" :type "html"))
                     ((string= file "page") (make-pathname :directory `(:relative "build" ,@(butlast dirs)) :name "index" :type "html"))
                     (t                     (make-pathname :directory `(:relative "build" ,@(butlast dirs) ,file) :name "index" :type "html")))))
    (let ((symbol-routes (find-symbol "ROUTES" pkg))
          (symbol-render (find-symbol "RENDER" pkg)))
      (flet ((render-multpl ()
               (dolist (route (funcall (symbol-function symbol-routes)))
                 (apply #'sta6:spit
                        ;; TODO: THIS IS A HACK
                        ;;       only works for 1-depth dyn route.
                        (make-pathname
                          :directory (append
                                        '(:relative "build")
                                        (butlast
                                          (mapcan
                                            (lambda (dir)
                                              (if (and (>= (length dir) 3)
                                                      (char= (char dir 0) #\+)
                                                      (char= (char dir (1- (length dir))) #\+))
                                                (uiop:split-string route :separator "/")
                                                (list dir)))
                                            dirs)))
                          :name "index"
                          :type "html")
                        (symbol-function symbol-render)
                        (list route))))
             (render-single ()
               (apply #'sta6:spit
                                  out
                                  (symbol-function symbol-render)
                                  '())))
        (if symbol-routes
              (render-multpl)
              (render-single))))))

(defun sta6:build ()
  (let ((base (uiop:ensure-directory-pathname (truename "src/pages/"))))
    (flet ((extract-package-name (filepath)
             (let* ((file-dirs (cdr (pathname-directory filepath)))
                    (base-dirs (cdr (pathname-directory base)))
                    (dirs      (nthcdr (length base-dirs) file-dirs)))
               (format nil "~{~A/~}~A"
                           dirs
                           (pathname-name filepath)))))
      (mapc #'sta6:render (mapcar #'extract-package-name (sta6:walk base))))))

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
