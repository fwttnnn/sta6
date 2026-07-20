# What is `sta6`?

As simple as it gets, `sta6` is a tiny static site generator (bundler) that turns `pages/*.lisp` into `pages/*.html`, with support for dynamic routes [[1](/docs/routing)].

`sta6`, and many other SSGs are intended for content-driven sites (e.g., blogs, docs, wiki).

Rather than providing built-in Markdown support, `sta6` lets you integrate any Markdown parser amongst the library of Common Lisp [[2](/docs/3rd-party/markdown)].

Using an SSG does not mean your site can't be interactive. You can use JavaScript/TypeScript to bring a simple interactivity to your site [[3](/docs/3rd-party/javascript)].

If your site requires richer client-side interactions (i.e., DOM manipulation), then consider adding an external library:

  - [Mithril](https://mithril.js.org/)
  - [React](https://react.dev/)
  - [Vue](https://vuejs.org/)

You can create `layouts`, and `components` (example: [fwttnnn.com/](https://github.com/fwttnnn/fwttnnn.com/tree/master/src)). Basically, `sta6` tries to do what `Next.js` is capable of.
