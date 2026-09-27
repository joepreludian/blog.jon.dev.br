// Theme toggle. The boot script in _includes/head.html has already put a
// saved choice on <html> before the first paint. This wires the LIGHT | DARK
// buttons, keeps their pressed state and the browser chrome colour in step
// with the theme showing, and announces every change as a `themechange`
// event on document so other scripts (the Mermaid loader) can redraw.
(function () {
  "use strict";

  var root = document.documentElement;
  var deviceDark = window.matchMedia("(prefers-color-scheme: dark)");
  var buttons = document.querySelectorAll("[data-theme-choice]");
  var metas = Array.prototype.map.call(
    document.querySelectorAll('meta[name="theme-color"]'),
    function (meta) {
      return { element: meta, deviceColour: meta.getAttribute("content") };
    }
  );

  // `data-theme` on <html> is the reader's choice for this page; storage
  // only carries it to the next one. Absent means "follow the device".
  function chosen() {
    var theme = root.getAttribute("data-theme");
    return theme === "light" || theme === "dark" ? theme : null;
  }

  function showing() {
    return chosen() || (deviceDark.matches ? "dark" : "light");
  }

  function paint() {
    var theme = showing();
    Array.prototype.forEach.call(buttons, function (button) {
      var pressed = button.getAttribute("data-theme-choice") === theme;
      button.setAttribute("aria-pressed", pressed ? "true" : "false");
    });

    // With a choice made, the device-keyed metas would be wrong half the
    // time, so both take the surface actually showing.
    var surface = chosen()
      ? window.getComputedStyle(root).getPropertyValue("--surface-page").trim()
      : null;
    metas.forEach(function (meta) {
      meta.element.setAttribute("content", surface || meta.deviceColour);
    });
  }

  function announce() {
    document.dispatchEvent(new CustomEvent("themechange", { detail: { theme: showing() } }));
  }

  Array.prototype.forEach.call(buttons, function (button) {
    button.addEventListener("click", function () {
      var theme = button.getAttribute("data-theme-choice");
      root.setAttribute("data-theme", theme);
      try {
        localStorage.setItem("theme", theme);
      } catch (e) {
        // Storage blocked: the choice holds for this page only.
      }
      paint();
      announce();
    });
  });

  deviceDark.addEventListener("change", function () {
    if (!chosen()) {
      paint();
      announce();
    }
  });

  paint();
})();
