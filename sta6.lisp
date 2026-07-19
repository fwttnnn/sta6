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

(defun sta6:render (pkg-name *route-cache*)
  (let  ((dirs (uiop:split-string pkg-name :separator "/"))
         (pkg  (find-package (string-upcase (concatenate 'string "pages/" pkg-name)))))
    (let ((symbol-routes (find-symbol "ROUTES" pkg))
          (symbol-render (find-symbol "RENDER" pkg)))
      (flet ((render-multpl ()
               (let ((routes (funcall (symbol-function symbol-routes)))
                     (dyn-path (format nil "~{~a~^/~}" (if (string= (car (last dirs)) "page")
                                                           (butlast dirs)
                                                           dirs))))
                 (setf (gethash dyn-path *route-cache*) routes)
                 (flet ((replace-dyn-routes (dyn-routes)
                          (labels ((recurse (dyn-routes)
                                     (when (null dyn-routes)
                                       (return-from recurse nil))
                                     (let ((slug (car (last dyn-routes)))
                                           (cache (gethash (format nil "~{~a~^/~}" dyn-routes) *route-cache*)))
                                       (if (and (>= (length slug) 3)
                                                (char= (char slug 0) #\+)
                                                (char= (char slug (1- (length slug))) #\+))
                                         (append (recurse (butlast dyn-routes)) (list cache))
                                         (append (recurse (butlast dyn-routes)) (list slug))))))
                            (recurse dyn-routes)))
                        (expand-dyn-routes (dyn-routes-replaced)
                          (labels ((recurse-expand (route-prefix expanded-prefix rest)
                                     (if (null rest)
                                         (list (list (reverse route-prefix)
                                                     (reverse expanded-prefix)))
                                         (let ((next (first rest)))
                                           (if (listp next)
                                               (loop for x in next
                                                     append (recurse-expand (cons x route-prefix)
                                                                            (cons x expanded-prefix)
                                                                            (rest rest)))
                                               (recurse-expand (cons next route-prefix)
                                                               expanded-prefix
                                                               (rest rest)))))))
                             (recurse-expand (list (first dyn-routes-replaced))
                                             nil
                                             (rest dyn-routes-replaced)))))
                   (dolist (entry (expand-dyn-routes (replace-dyn-routes (uiop:split-string dyn-path :separator "/"))))
                     (destructuring-bind (route args) entry
                       (apply #'sta6:spit
                              (make-pathname
                                :directory `(:relative "build" ,@(mapcan (lambda (dir)
                                                                           (uiop:split-string dir :separator "/"))
                                                                         route))
                                :name "index"
                                :type "html")
                              (symbol-function symbol-render)
                              args))))))
             (render-single ()
               (let* ((file (car (last dirs)))
                      (out-path (cond ((string= file "404")  (make-pathname :directory '(:relative "build") :name "404" :type "html"))
                                      ((string= file "page") (make-pathname :directory `(:relative "build" ,@(butlast dirs)) :name "index" :type "html"))
                                      (t                     (make-pathname :directory `(:relative "build" ,@(butlast dirs) ,file) :name "index" :type "html")))))
                 (apply #'sta6:spit
                      out-path
                      (symbol-function symbol-render)
                      '()))))
        (if symbol-routes
              (render-multpl)
              (render-single))))))

(defun sta6:build ()
  (let ((base (uiop:ensure-directory-pathname (truename "src/pages/"))))
    (flet ((extract-package-name (filepath)
             (let* ((file-dirs (rest (pathname-directory filepath)))
                    (base-dirs (rest (pathname-directory base)))
                    (dirs      (nthcdr (length base-dirs) file-dirs)))
               (format nil "~{~A/~}~A"
                           dirs
                           (pathname-name filepath)))))
      (let ((route-cache (make-hash-table :test #'equal)))
        (dolist (pkg-name (mapcar #'extract-package-name (sta6:walk base)))
          (sta6:render pkg-name route-cache))))))

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
