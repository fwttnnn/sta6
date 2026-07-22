entry="dynamic-routes"

sbcl --noinform \
     --noprint \
     --non-interactive \
     --eval '((lambda ()
               (require :asdf)
               (load "~/quicklisp/setup.lisp")
               (push #p"./" asdf:*central-registry*)
               (push #p"../../" asdf:*central-registry*)))' \
     --eval "(ql:quickload :$entry)" \
     --eval "($entry:main)"
