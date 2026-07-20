(defpackage #:components/links
  (:use #:cl)
  (:export #:render))

(defun components/links:render ()
  (sta6:html
    (:ul
      (let* ((root (truename "src/docs/"))
             (docs (mapcar (lambda (path)
                             (namestring
                               (make-pathname
                                 :type nil
                                 :defaults (uiop:enough-pathname path root))))
                           (sta6:walk (uiop:ensure-directory-pathname root)))))
        ;; TODO: clean this up,
        ;;       this shit is beyond fucked
        (labels ((recurse (paths lst)
                   (when (eq paths nil)
                     (return-from recurse (reverse lst)))
                   (let* ((path (car paths))
                          (fragments (uiop:split-string path :separator "/")))
                     (labels ((recurse-fragments (fragments tree)
                                (when (eq fragments nil)
                                  (return-from recurse-fragments tree))
                                (let* ((fragment (car fragments))
                                       (cell (assoc fragment tree :test #'string=)))
                                  (if (eq cell nil)
                                    (acons fragment
                                           (recurse-fragments (cdr fragments) '())
                                           tree)
                                    (progn
                                      (setf (cdr cell)
                                            (reverse (recurse-fragments (cdr fragments) (cdr cell))))
                                      (reverse tree))))))
                       (setf lst (recurse-fragments fragments lst))
                       (recurse (cdr paths) lst))))
                 (render-node (node parent-path)
                   (let* ((name (car node))
                          (child (cdr node))
                          (current-path (format nil "~a/~a" parent-path name)))
                      (:li
                        (if child
                            (format nil "~a/" name)
                            (:a :href current-path (format nil "~a/" name)))
                        (when child
                          (:ul (loop for c in child do
                                 (render-node c current-path))))))))
          (loop for node in (recurse docs '()) do
            (render-node node "/docs")))))))
