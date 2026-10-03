// The home hero's control panel (_includes/cockpit.html). The lamps that
// stand for something the build knows are lit in the markup; this lights
// the ones only the browser knows, and wires the controls:
//
//   panel   the theme lamps and toggle press the header's own LIGHT | DARK
//           buttons, so theme.js stays the one owner of the theme. This only
//           repaints when theme.js announces a `themechange`.
//   lang    the toggle is a plain link; this flips the lever before leaving.
//   lights  held down, the push-button lights every lamp.
//   lamps   the dimmer sets the lamps' output in five detents.
//
// It also runs the power-up. The stylesheet keeps every lamp dark until
// `is-ready` is on the panel, so the sequence never starts from a lit one.
(function () {
  "use strict";

  var panel = document.querySelector("[data-cockpit]");
  if (!panel) {
    return;
  }

  var root = document.documentElement;
  var reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  var each = function (list, visit) {
    Array.prototype.forEach.call(list, visit);
  };

  // --- panel: the theme showing ---------------------------------------

  var themeLamps = panel.querySelectorAll("[data-cockpit-theme]");
  var themeSwitch = panel.querySelector('[data-cockpit-switch="theme"]');

  // Same rule as theme.js: the reader's choice on <html>, else the device.
  function showing() {
    var theme = root.getAttribute("data-theme");
    if (theme === "light" || theme === "dark") {
      return theme;
    }
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  function choose(theme) {
    var button = document.querySelector('[data-theme-choice="' + theme + '"]');
    if (button) {
      button.click();
    }
  }

  function paintTheme() {
    var theme = showing();
    each(themeLamps, function (lamp) {
      var on = lamp.getAttribute("data-cockpit-theme") === theme;
      lamp.classList.toggle("is-on", on);
      lamp.setAttribute("aria-pressed", on ? "true" : "false");
    });
    if (themeSwitch) {
      themeSwitch.classList.toggle("is-down", theme === "dark");
      themeSwitch.setAttribute("aria-checked", theme === "dark" ? "true" : "false");
    }
  }

  each(themeLamps, function (lamp) {
    lamp.addEventListener("click", function () {
      choose(lamp.getAttribute("data-cockpit-theme"));
    });
  });
  if (themeSwitch) {
    themeSwitch.addEventListener("click", function () {
      choose(showing() === "dark" ? "light" : "dark");
    });
  }
  document.addEventListener("themechange", paintTheme);

  // --- lang: flip, then go ---------------------------------------------

  var langSwitch = panel.querySelector('[data-cockpit-switch="lang"]');
  if (langSwitch && !reducedMotion) {
    var startsDown = langSwitch.classList.contains("is-down");

    langSwitch.addEventListener("click", function (event) {
      // A modified click opens a tab; the lever stays where it is.
      if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
        return;
      }
      event.preventDefault();
      langSwitch.classList.toggle("is-down", !startsDown);
      window.setTimeout(function () {
        window.location.href = langSwitch.href;
      }, 160);
    });

    // Back from the other language, the browser may restore this page as it
    // was left, lever flipped. Put it back.
    window.addEventListener("pageshow", function () {
      langSwitch.classList.toggle("is-down", startsDown);
    });
  }

  // --- lights: test, while held ----------------------------------------

  var testButton = panel.querySelector("[data-cockpit-test]");
  if (testButton) {
    var setTest = function (on) {
      testButton.classList.toggle("is-pressed", on);
      panel.classList.toggle("is-test", on);
    };

    testButton.addEventListener("pointerdown", function () {
      setTest(true);
    });
    ["pointerup", "pointerleave", "pointercancel", "blur", "keyup"].forEach(function (type) {
      testButton.addEventListener(type, function () {
        setTest(false);
      });
    });
    testButton.addEventListener("keydown", function (event) {
      if (event.key === " " || event.key === "Enter") {
        setTest(true);
      }
    });
  }

  // --- lamps: the dimmer -----------------------------------------------

  var knob = panel.querySelector("[data-cockpit-knob]");
  var OUTPUTS = [0.45, 0.6, 0.75, 0.88, 1];
  var detent = OUTPUTS.length - 1;

  function setDetent(next) {
    detent = Math.max(0, Math.min(OUTPUTS.length - 1, next));
    var output = OUTPUTS[detent];
    panel.style.setProperty("--brt", String(output));
    // The bulbs' hot spots fall off faster than the lamp does.
    panel.style.setProperty("--hot-mix", Math.round(output * output * 90) + "%");
    knob.style.setProperty("--turn", -120 + detent * 60 + "deg");
    knob.setAttribute("aria-valuenow", String(detent + 1));
  }

  if (knob) {
    // The right half turns it up, the left half down.
    knob.addEventListener("click", function (event) {
      var box = knob.getBoundingClientRect();
      setDetent(detent + (event.clientX < box.left + box.width / 2 ? -1 : 1));
    });
    knob.addEventListener("keydown", function (event) {
      var steps = { ArrowRight: 1, ArrowUp: 1, ArrowLeft: -1, ArrowDown: -1 };
      var target = { Home: 0, End: OUTPUTS.length - 1 };
      if (event.key in steps) {
        setDetent(detent + steps[event.key]);
      } else if (event.key in target) {
        setDetent(target[event.key]);
      } else {
        return;
      }
      event.preventDefault();
    });
  }

  // --- power-up ----------------------------------------------------------

  // Every lamp dark, then each one lit in turn as under a lights test, then
  // the panel settles to its real state.
  function powerUp() {
    var lamps = panel.querySelectorAll(".cockpit-lamp");
    var step = 55;
    var start = 260;

    if (!reducedMotion) {
      each(lamps, function (lamp, index) {
        lamp.classList.add("is-dark");
        window.setTimeout(function () {
          lamp.classList.remove("is-dark");
        }, start + index * step);
      });
      panel.classList.add("is-test");
      window.setTimeout(function () {
        panel.classList.remove("is-test");
      }, start + lamps.length * step + 500);
    }
    panel.classList.add("is-ready");
  }

  paintTheme();
  powerUp();
})();
