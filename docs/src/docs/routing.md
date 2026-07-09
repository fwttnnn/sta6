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
    [slug]/
      page.lisp -> /blog/<slug>
```

However, you cannot simply treat a file as dynamic routing:

```text
src/pages/
  blog/
    [slug].lisp -> does not work
```

As much as I like this to work, `sbcl` can't find files that starts with '[' (because `sbcl` escapes it into '^['), at least that's (only) on MS-DOS, I haven't tried compiling with *nix systems.

Note that I might change how `sta6` parse dynamic route files, perhaps something like `+slug+.lisp`.

With dynamic routes, you need to tell `sta6` what routes are available:

```
(defun pages/blog/[slug]/page:routes ()
  '("my-first-post" "how-to-use-sta6" "sta6-for-static-websites"))
```

Which yields these routes:

  - /blog/my-first-post
  - /blog/how-to-use-sta6
  - /blog/sta6-for-static-websites

Lastly, the routes are gonna get passed through `render`:

```
(defun pages/blog/[slug]/page:render (slug)
  (:p (format nil "at ~a" slug)))
```

