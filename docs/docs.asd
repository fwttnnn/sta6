(asdf:defsystem "docs"
  :depends-on ("sta6" "3bmd" "3bmd-ext-code-blocks")
  :serial t
  :components ((:file "src/layouts/main")
               (:file "src/pages/docs/[slug]/page")
               (:file "src/pages/docs/page")
               (:file "src/pages/page")
               (:file "docs")))
