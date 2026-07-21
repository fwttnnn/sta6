# JavaScript

`sta6` does not bundle JavaScript automatically into the `build/` directory (might change in the future), thus you need to copy out `*.js` files into the `build/` directory manually (e.g., `cp src/*.js build/`).

In one of your page (or layout), import them via the `(:script)` tag:

```
(:script :type "module"
         :src "/app.js")
```

You can utilize CDN(s) to use JavaScript libraries. 
