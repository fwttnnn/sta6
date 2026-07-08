#!/usr/bin/bash

while [[ $# -gt 0 ]]; do
  case "$1" in
    --serve)
      serve build/
      exit 0
      ;;
    --deploy)
      vercel --prod
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

sbcl --noinform \
     --noprint \
     --non-interactive \
     --eval '((lambda ()
               (require :asdf)
               (load "~/quicklisp/setup.lisp")
               (push #p"./" asdf:*central-registry*)
               (push #p"../" asdf:*central-registry*)))' \
     --eval '(ql:quickload :docs)' \
     --eval '(docs:main)'

cp -r src/styles build/
