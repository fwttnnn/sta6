(asdf:defsystem "hello-world"
  :depends-on ("sta6")
  :serial t
  :components ((:file "src/pages/page")
               ;; NOTE: make sure the entry point
               ;;       last one that's loaded.
               (:file "hello-world")))
