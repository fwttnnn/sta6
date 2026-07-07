# Quickstart

To get started, install the latest version of sta6 from Quicklisp:

```
(ql:quickload :sta6)
```

Then, create a new project:

```sh
mkdir app
cd app
```

Next, define your system by creating a file called `app.asd` with the following contents:

```
(asdf:defsystem "app"
  :depends-on ("sta6")
  :components ((:file "app")))
```

The minimal entry point should call `sta6:build`. Here is `app.lisp`:

```
(defpackage #:app
  (:use #:cl)
  (:export #:main))

(defun main ()
  (sta6:build))
```

The contents are located in `src/pages`.

Each page should define a package whose name matches its path. For example, the page `src/pages/index.lisp` should define the package `pages/index`.

Each page should export a function named `render`, which is the entry point used by sta6 to generate HTML.

Create your homepage at `src/pages/index.lisp`:

```
(defpackage #:pages/index
  (:use #:cl)
  (:export #:render))

(defun pages/index:render ()
  (sta6:html5
    (:p "hello, from sta6!")))
```

Finally, run the app with your favorite Common Lisp implementation:

```
(push #p"./" asdf:*central-registry*)
(ql:quickload :app)
(app:main)
```

For example, using SBCL:

```sh
$ sbcl
* (push #p"./" asdf:*central-registry*)
* (ql:quickload :app)
* (app:main)
```

The generated HTML files will be located in the `build/` directory.
