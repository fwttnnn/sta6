(defpackage #:pages/docs/page
  (:use #:cl)
  (:export #:render))

(defun pages/docs/page:render ()
  (layouts/main:html5
    (:p "hi docs/")))
