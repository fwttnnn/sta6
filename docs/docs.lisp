(defpackage #:docs
  (:use #:cl)
  (:export #:main))

(defun docs:main ()
  (setf 3bmd-code-blocks:*code-blocks* t)
  (sta6:build))
