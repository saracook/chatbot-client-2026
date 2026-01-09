This site is built with Jekyll - Quickstart is here: 
https://jekyllrb.com/docs/

To build locally, use this command, which will override the site.baseurl value that is needed when it is built on GitHub pages

```
bundle exec jekyll serve --incremental --config _config.yml,_local.yml
```

Incremental is optional, but useful. It will regenerate the site on localhost for page-level changes, but changes to _config.yml or the files in _data/ may require a restart.
