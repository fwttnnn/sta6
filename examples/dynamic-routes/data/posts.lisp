(defpackage #:data/posts
  (:use #:cl)
  (:export #:+data+))

(defparameter data/posts:+data+
  '((:year 2048
     :title "My first post"
     :content "...")
    (:year 2048
     :title "Hi"
     :content "...")
    (:year 2049
     :title "A year after"
     :content "...")))
