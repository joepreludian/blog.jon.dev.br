// Disqus comments, loaded on request. Nothing is fetched from Disqus until the
// reader presses the load button. Disqus picks its light or dark palette from
// the page's colours when it draws, so a `themechange` (from theme.js) redraws
// the thread to match.
(function () {
  "use strict";

  var section = document.querySelector("[data-comments]");
  if (!section) {
    return;
  }

  var button = section.querySelector("[data-comments-load]");
  var gate = section.querySelector("[data-comments-gate]");
  var loaded = false;

  function config() {
    this.page.url = section.getAttribute("data-url");
    this.page.identifier = section.getAttribute("data-identifier");
    this.page.title = section.getAttribute("data-title");
    this.language = section.getAttribute("data-language");
  }

  function load() {
    if (loaded) {
      return;
    }
    loaded = true;
    gate.hidden = true;

    window.disqus_config = config;
    var script = document.createElement("script");
    script.src = "https://" + section.getAttribute("data-shortname") + ".disqus.com/embed.js";
    script.setAttribute("data-timestamp", String(Date.now()));
    script.async = true;
    document.head.appendChild(script);
  }

  button.addEventListener("click", load);

  // Arriving from a link to #comments means the reader already asked.
  if (window.location.hash === "#comments") {
    load();
  }

  document.addEventListener("themechange", function () {
    if (loaded && window.DISQUS) {
      window.DISQUS.reset({ reload: true, config: config });
    }
  });
})();
