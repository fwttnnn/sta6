(defpackage #:pages/blog/+year+/+slug+/page
  (:use #:cl)
  (:export #:routes
           #:render))

(defun pages/blog/+year+/+slug+/page:routes (year)
  (mapcar (lambda (post)
            (substitute #\-
                        #\Space
                        (string-downcase (getf post :title))))
            (remove-if-not (lambda (post)
                             (= year (getf post :year)))
                           data/posts:+data+)))

(defun pages/blog/+year+/+slug+/page:render (year slug)
  (sta6:html5
    (let ((post (find-if (lambda (post)
                           (and (= year (getf post :year))
                                (string= slug (substitute #\-
                                                          #\Space
                                                          (string-downcase (getf post :title))))))
                               data/posts:+data+)))
      (:p (format nil "~a" (getf post :title))
        (:small :style "margin: 0 .4rem;" (format nil "(~a)" year))))))
