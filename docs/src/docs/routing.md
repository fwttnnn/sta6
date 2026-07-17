# Routing

`sta6` follows a file-based routing system:

```text
src/pages/
  page.lisp       -> /
  about.lisp      -> /about
  blog/
    posts.lisp    -> /blog/posts
```

You can also do dynamic routing:

```text
src/pages/
  blog/
    +slug+/
      page.lisp -> /blog/<slug>
```

Or, name a file as `+slug+`:

```text
src/pages/
  blog/
    +slug+.lisp -> /blog/<slug>
```

With dynamic routes, you need to tell `sta6` what routes are available:

```
(defun pages/blog/+slug+:routes ()
  '("my-first-post" "how-to-use-sta6" "sta6-for-static-websites"))
```

Which yields these routes:

  - /blog/my-first-post
  - /blog/how-to-use-sta6
  - /blog/sta6-for-static-websites

Lastly, each route(s) are gonna get passed through `render`:

```
(defun pages/blog/+slug+:render (slug)
  (:p (format nil "at ~a" slug)))
```

