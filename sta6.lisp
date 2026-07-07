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

(defun sta6:render (pkg-name)
  (let* ((fname (pathname-name pkg-name))
         (dirs  (butlast (uiop:split-string pkg-name :separator "/")))
         (pkg   (find-package (string-upcase (concatenate 'string "pages/" pkg-name))))
         (out   (cond ((string= fname "404")  (make-pathname :directory '(:relative "build") :name "404" :type "html"))
                      ((string= fname "page") (make-pathname :directory `(:relative "build" ,@dirs) :name "index" :type "html"))
                      (t                      (make-pathname :directory `(:relative "build" ,@dirs ,fname) :name "index" :type "html")))))
    (sta6:spit out (symbol-function (find-symbol "RENDER" pkg)))))

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
