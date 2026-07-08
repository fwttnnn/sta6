(defpackage #:pages/docs/page
  (:use #:cl)
  (:export #:render))

(defun pages/docs/page:render ()
  (layouts/main:html5
    (:h1 "Documentation")
    (:p
      (multiple-value-bind (sec min hour day month year)
          (decode-universal-time (get-universal-time))
        (format nil "last build: ~4,'0d-~2,'0d-~2,'0d~%" year month day)))
    (:ul
      (let ((docs (mapcar (lambda (path)
                            (pathname-name path))
                         (sta6:walk (uiop:ensure-directory-pathname (truename "src/docs/"))))))
        (loop for doc in docs do
          (:li (:a :href (format nil "/docs/~a" doc) (format nil "~a/" doc))))))))



