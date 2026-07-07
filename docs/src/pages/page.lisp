(defpackage #:pages/page
  (:use #:cl)
  (:export #:render))

(defun pages/page:render ()
  (layouts/main:html5
    (:h1
      "sta6: "
      (:small "sta(six), static"))
    (:p "static site generator (bundler), written in Common Lisp.")
    (:p (multiple-value-bind (sec min hour day month year)
            (decode-universal-time (get-universal-time))
          (format nil "~4,'0d-~2,'0d-~2,'0d~%" year month day)))
    (:div
      (dotimes (i 10)
        (:span i)))
    (:ul 
      (:li (:a :href "/docs/quickstart" "quickstart/")
      (:li (:a :href "/docs/routing" "routing/"))))))
