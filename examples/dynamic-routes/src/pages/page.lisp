(defpackage #:pages/page
  (:use #:cl)
  (:export #:render))

(defun pages/page:render ()
  (sta6:html5
    (:ul
      (let ((years (remove-duplicates
                     (mapcar (lambda (post)
                               (getf post :year))
                             data/posts:+data+))))
        (loop for year in years do
          (:li (:a :href (format nil "blog/~a/" year) year)
            (:ul
              (let ((slugs (mapcar (lambda (post)
                             (substitute #\-
                                         #\Space
                                         (string-downcase (getf post :title))))
                             (remove-if-not (lambda (post)
                                              (= year (getf post :year)))
                                            data/posts:+data+))))
                (loop for slug in slugs do
                  (:li (:a :href (format nil "blog/~a/~a/" year slug) slug)))))))))))
