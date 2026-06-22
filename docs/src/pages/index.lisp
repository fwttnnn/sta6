(defpackage #:pages/index
  (:use #:cl)
  (:export #:render))

(defun pages/index:render ()
  (layouts/main:html5
    (:h1
      "sta6: "
      (:small "sta(six), static"))
    (:p "static site generator (bundler), written in Common Lisp.")))
