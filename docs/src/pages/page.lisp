(defpackage #:pages/page
  (:use #:cl)
  (:export #:render))

(defun pages/page:render ()
  (layouts/main:html5
    (:h1
      "sta6: "
      (:small "sta(six), static "
        (:a
          :style "text-decoration: none; color: inherit;"
          :href "/important"
          (:small
             :style "font-size: 0.4em; background: #ADADFF;"
             "BETA"))))
    (:p "static site generator, for Common Lisp.")
    (:ul
      (:li (:a :href "/docs/overview" "what is sta6?"))
      (:li (:a :href "https://github.com/fwttnnn/sta6" :target "_blank" "github")))
    (:footer
      (:small "generated with " (:code "sta6") "."))))
