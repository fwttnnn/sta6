(defpackage #:layouts/main
  (:use #:cl)
  (:export #:html5))

(defmacro layouts/main:html5 (&body body)
  `(sta6:html5
     (:head
       (:title "sta6 :: documentation")
       (:link :rel "stylesheet" :href "/styles/glob.css")
       (:meta :charset "UTF-8")
       (:meta :name "viewport" :content "width=device-width, initial-scale=1.0"))
     (:header
       (:nav
         (:a :href "/"     "home/")
         (:a :href "/docs" "docs/")))
     ,@body))
