(defpackage #:pages/docs/quickstart
  (:use #:cl)
  (:export #:render))

(defun pages/docs/quickstart:render ()
  (layouts/main:html5
    (:h1 "Quickstart")
    (:p "To get started, install the latest version of sta6 from Quicklisp:")
    (:pre
      (:code
        "$ (ql:quickload :sta6)"))
    (:p "Then, create a new project:")
    (:pre
      (:code
"$ mkdir app
$ cd app"))
    (:p "Next, define your system by creating a file called `app.asd`, with the following contents:")
    (:pre
      (:code
"(asdf:defsystem \"app\"
  :depends-on (\"sta6\")
  :components ((:file \"app\")))"))
    (:p "The minimal entry point should call `(sta6:build)`. Here is `app.lisp`:")
    (:pre
      (:code
"(defpackage #:app
  (:use #:cl)
  (:export #:main))

(defun main ()
  (sta6:build))"))
  (:p "The contents are located in `src/pages`. Each page should define a package named as it's path," (:br) "for example: the page `src/pages/index.lisp` should be defined as `pages/index`.")
  (:p "Each page should export a function called `render`, as it is the pin point for sta6 to render html.")
  (:p "Create your homepage `src/pages/index.lisp`:")
  (:pre
    (:code
"(defpackage #:pages/index
  (:use #:cl)
  (:export #:render))

(defun pages/index:render ()
  (sta6:html5
    (:p \"hello, from sta6!\")))"))
  (:p "Finally, run the app with your fav Common Lisp implementation:")
  (:pre
    (:code
"$ sbcl
* (push #p\"./\" asdf:*central-registry*)
* (ql:quickload :app)
* (app:main)"))
  (:p "The generated html files will be located in the `build/` directory.")))
