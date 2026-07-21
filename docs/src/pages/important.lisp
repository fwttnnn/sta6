(defpackage #:pages/important
  (:use #:cl)
  (:export #:render))

(defun pages/important:render ()
  (layouts/main:html5
    (:h1 "Important Notes")
    (:p "as of the current build, " (:code "sta6") " is in it's BETA stage.")
    (:p (:code "sta6") " starts as a bundler for my personal page " (:a :href "https://fwttnnn.vercel.app/" :target "_blank" "fwttnnn.com") ", and it's currently in a slow and/or heavy development, so expect API-breaking changes.")
    (:h2
      :id "features"
      "features")
    (:p "what doesn't work:")
    (:ul
      (:li (:i "nested") " dynamic routing (implemented, see: " (:a :href "https://github.com/fwttnnn/sta6/commit/9110530ea63540e4ed9759b874c634e732121fde" :target "_blank" "9110530") ")")
      (:li (:code "sta6") " does not remove pages that's already built (e.g., adding /hi, then deleting " (:code "pages/hi.lisp") " after building won't delete /hi from the " (:code "build/") " folder)."))
    (:h2
      :id "artifacts"
      "artifacts")
    (:ul
      (:li "reddit post(s): "
        (:ul
          (:li (:a :href "https://www.reddit.com/r/suckless/s/nmDgXvtt1E" :target "_blank" "r/suckless"))))
      (:li "hn post(s): "
          (:ul
            (:li (:a :href "https://news.ycombinator.com/item?id=48994000" :target "_blank" "1st")))))))
