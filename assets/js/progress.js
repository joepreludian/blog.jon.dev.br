// Reading-progress bar for the post layout. Width tracks scroll depth.
(function () {
  "use strict";

  var bar = document.querySelector("[data-progress] .progress__bar");
  if (!bar) {
    return;
  }

  var queued = false;

  function update() {
    queued = false;
    var scrollable = document.documentElement.scrollHeight - window.innerHeight;
    var ratio = scrollable > 0 ? window.scrollY / scrollable : 0;
    var percent = Math.min(100, Math.max(0, ratio * 100));
    bar.style.width = percent.toFixed(1) + "%";
  }

  function onScroll() {
    if (queued) {
      return;
    }
    queued = true;
    window.requestAnimationFrame(update);
  }

  window.addEventListener("scroll", onScroll, { passive: true });
  window.addEventListener("resize", onScroll, { passive: true });
  update();
})();
