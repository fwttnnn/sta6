(defpackage #:layouts/main
  (:use #:cl)
  (:export #:html5))

(defmacro layouts/main:html5 (&body body)
  `(sta6:html5
     (:head
      (:title "sta6 :: documentation"))
     ,@body))
