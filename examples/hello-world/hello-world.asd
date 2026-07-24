(asdf:defsystem "hello-world"
  :depends-on ("sta6")
  :components ((:file "src/pages/page")
               ;; NOTE: make sure the entry point
               ;;       is the last one that's loaded.
               (:file "hello-world")))
