(defpackage #:pages/docs/[slug]/page
  (:use #:cl)
  (:export #:routes
           #:render))

(defun pages/docs/[slug]/page:routes ()
  (mapcar (lambda (path) (pathname-name path)) (sta6:walk (uiop:ensure-directory-pathname (truename "src/docs/")))))

(defun pages/docs/[slug]/page:render (slug)
  (layouts/main:html5
    (let* ((path (merge-pathnames (uiop:ensure-directory-pathname (truename "src/docs/")) (format nil "~a.md" slug)))
           (file (uiop:read-file-string path)))
      (:raw
        (with-output-to-string (out)
          (3bmd:parse-string-and-print-to-stream file out))))))
