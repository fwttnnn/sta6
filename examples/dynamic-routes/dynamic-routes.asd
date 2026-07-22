(asdf:defsystem "dynamic-routes"
  :depends-on ("sta6")
  :serial t
  :components ((:file "data/posts")
               (:file "src/pages/blog/+year+/+slug+/page")
               (:file "src/pages/blog/+year+/page")
               (:file "src/pages/page")
               ;; NOTE: make sure the entry point
               ;;       is the last one that's loaded.
               (:file "dynamic-routes")))
