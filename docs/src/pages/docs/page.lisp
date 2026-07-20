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
    (components/links:render)))

