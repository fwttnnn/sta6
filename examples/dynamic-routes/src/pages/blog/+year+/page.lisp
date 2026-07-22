(defpackage #:pages/blog/+year+/page
  (:use #:cl)
  (:export #:routes
           #:render))

(defun pages/blog/+year+/page:routes ()
  (remove-duplicates (mapcar (lambda (post)
                               (getf post :year))
                             data/posts:+data+)))

(defun pages/blog/+year+/page:render (year)
  (sta6:html5
    (:p (format nil "year: ~a" year))))
