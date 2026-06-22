(defpackage #:sta6
  (:use #:cl)
  (:export #:spit
           #:walk
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

(defun sta6:build ()
  (let* ((base (uiop:ensure-directory-pathname (truename "src/pages/")))
         (relatives (mapcar (lambda (file)
                              (namestring (make-pathname :type nil
                                                         :defaults (enough-namestring file base))))
                            (sta6:walk base))))
    (flet ((ends-with? (str suffix)
             (let ((str-length (length str))
                   (suffix-length (length suffix)))
               (and (>= str-length suffix-length)
                    (string= (subseq str (- str-length suffix-length)) suffix)))))
      (mapc (lambda (rel)
              (let ((pkg (find-package (string-upcase (concatenate 'string "pages/" rel))))
                    (out (cond ((string= rel "404")      (format nil "build/404.html"))
                               ((ends-with? rel "index") (format nil "build/~a.html" rel))
                               (t                        (format nil "build/~a/index.html" rel)))))
                (sta6:spit out (symbol-function (find-symbol "RENDER" pkg)))))
            relatives))))

(defmacro sta6:html5 (&rest tags)
  (let ((head '())
        (body '()))

    (dolist (tag tags)
      (cond
        ((and (consp tag) (eq (first tag) :head))
         (setf head (rest tag)))
        (t
         (push tag body))))

    `(let ((spinneret:*suppress-inserted-spaces* t)
           (spinneret:*html-style* :tree)
           (*print-pretty* nil))
       (format t "<!DOCTYPE html>~%")
       (format t "~a~%"
               (spinneret:with-html-string
                 (:html
                  (:head ,@head)
                  (:body ,@(nreverse body))))))))
