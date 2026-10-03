// giscus comments. The script goes in as soon as the page is parsed, and
// `data-loading="lazy"` holds the thread's frame back until the reader scrolls
// near it. The thread draws in giscus's own light or dark theme, and a
// `themechange` (from theme.js) tells the frame to switch.
(function () {
  "use strict";

  var section = document.querySelector("[data-comments]");
  if (!section) {
    return;
  }

  var origin = "https://giscus.app";

  // Same rule as theme.js: the reader's choice on <html>, else the device.
  function showing() {
    var theme = document.documentElement.getAttribute("data-theme");
    if (theme === "light" || theme === "dark") {
      return theme;
    }
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  function load() {
    var attrs = {
      "data-repo": section.getAttribute("data-repo"),
      "data-repo-id": section.getAttribute("data-repo-id"),
      "data-category": section.getAttribute("data-category"),
      "data-category-id": section.getAttribute("data-category-id"),
      "data-mapping": "specific",
      "data-term": section.getAttribute("data-term"),
      "data-strict": "1",
      "data-reactions-enabled": "0",
      "data-emit-metadata": "0",
      "data-input-position": "bottom",
      "data-theme": showing(),
      "data-lang": section.getAttribute("data-language"),
      "data-loading": "lazy",
      crossorigin: "anonymous"
    };

    var script = document.createElement("script");
    script.src = origin + "/client.js";
    script.async = true;
    Object.keys(attrs).forEach(function (name) {
      script.setAttribute(name, attrs[name]);
    });
    section.appendChild(script);
  }

  load();

  document.addEventListener("themechange", function (event) {
    var frame = section.querySelector("iframe.giscus-frame");
    if (frame && frame.contentWindow) {
      frame.contentWindow.postMessage({ giscus: { setConfig: { theme: event.detail.theme } } }, origin);
    }
  });
})();
