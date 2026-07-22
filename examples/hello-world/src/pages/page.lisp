(defpackage #:pages/page
  (:use #:cl)
  (:export #:render))

(defun pages/page:render ()
  (sta6:html5
    (:img :width (/ 500.0 3)
          :src "https://twobithistory.org/images/sicp.jpg")
    (:br)
    (:br)
    (:span "Hello, from Common Lisp.")
    (:ul
      (loop for x from 1 to 3 do
        (:li x)))))
