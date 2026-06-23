(defpackage #:sta6
  (:use #:cl)
  (:export #:spit
           #:walk
           #:render
           #:build
           #:html5))

(defun sta6:spit (path thunk)
  (ensure-directories-exist path)
  (with-open-file (out path :direction :output
                            :if-exists :supersede
                            :if-does-not-exist :create)
    (let ((*standard-output* out))
      (funcall thunk))))
  
(defun sta6:walk (dir)
  (append
    (uiop:directory-files dir)
    (mapcan #'sta6:walk
            (uiop:subdirectories dir))))

(defun sta6:render (file)
  (let ((name (pathname-name file))
        (extn (pathname-type file))
        (path (namestring (make-pathname :type nil
                                         :defaults file))))
    (cond ((string= extn "md") '())
          ((string= extn "lisp")
             (let ((pkg (find-package (string-upcase (concatenate 'string "pages/" path))))
                   (out (cond ((string= name "404")   (format nil "build/404.html"))
                              ((string= name "index") (format nil "build/~a.html" path))
                              (t                      (format nil "build/~a/index.html" path)))))
               (sta6:spit out (symbol-function (find-symbol "RENDER" pkg))))))))

(defun sta6:build ()
  (let* ((base (uiop:ensure-directory-pathname (truename "src/pages/")))
         (files (mapcar (lambda (file) (namestring (make-pathname :defaults (enough-namestring file base))))
                        (sta6:walk base))))
    (mapc #'sta6:render files)))

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
