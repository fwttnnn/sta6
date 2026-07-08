(defpackage #:pages/page
  (:use #:cl)
  (:export #:render))

(defun pages/page:render ()
  (layouts/main:html5
    (:h1
      "sta6: "
      (:small "sta(six), static"))
    (:p "static site generator, for Common Lisp.")))
