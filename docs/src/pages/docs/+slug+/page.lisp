(defpackage #:pages/docs/+slug+/page
  (:use #:cl)
  (:export #:routes
           #:render))

(defun pages/docs/+slug+/page:routes ()
  (let ((root (truename "src/docs/")))
    (mapcar
      (lambda (path)
        (namestring
          (make-pathname
            :type nil
            :defaults (uiop:enough-pathname path root))))
      (sta6:walk root))))

(defun pages/docs/+slug+/page:render (slug)
  (layouts/main:html5
    (let* ((path (merge-pathnames (format nil "~a.md" slug)
                                  (uiop:ensure-directory-pathname (truename "src/docs/"))))
           (file (uiop:read-file-string path)))
      (:raw
        (with-output-to-string (out)
          (3bmd:parse-string-and-print-to-stream file out))))))
