(asdf:defsystem "docs"
  :depends-on ("sta6")
  :components ((:file "src/layouts/main")
               (:file "src/pages/index")
               (:file "docs")))
