# Markdown

`sta6` does not bundle markdown libraries by default. You have to use an external `.md` parser, available options:

  - [3bmd](https://github.com/3b/3bmd)
  - [cl-markdown](https://github.com/hraban/cl-markdown)

Which can be rendered using the special `(:raw ...)` tag, for example:

```
(:raw
  (markdown->html "blog/my-first-post.md"))
```
