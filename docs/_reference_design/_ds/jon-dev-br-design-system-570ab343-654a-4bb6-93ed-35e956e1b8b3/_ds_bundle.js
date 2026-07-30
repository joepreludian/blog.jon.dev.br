/* @ds-bundle: {"format":4,"namespace":"JonDevBrDesignSystem_570ab3","components":[{"name":"Badge","sourcePath":"components/display/Badge.jsx"},{"name":"Card","sourcePath":"components/display/Card.jsx"},{"name":"Tag","sourcePath":"components/display/Tag.jsx"},{"name":"Button","sourcePath":"components/forms/Button.jsx"},{"name":"Input","sourcePath":"components/forms/Input.jsx"},{"name":"Figure","sourcePath":"components/media/Figure.jsx"},{"name":"Rule","sourcePath":"components/media/Rule.jsx"},{"name":"Callout","sourcePath":"components/technical/Callout.jsx"},{"name":"Checklist","sourcePath":"components/technical/Checklist.jsx"},{"name":"CodeBlock","sourcePath":"components/technical/CodeBlock.jsx"},{"name":"HomePage","sourcePath":"ui_kits/site/HomePage.jsx"},{"name":"PostPage","sourcePath":"ui_kits/site/PostPage.jsx"},{"name":"ProjectsPage","sourcePath":"ui_kits/site/ProjectsPage.jsx"},{"name":"ResumePage","sourcePath":"ui_kits/site/ResumePage.jsx"},{"name":"SiteFooter","sourcePath":"ui_kits/site/SiteFooter.jsx"},{"name":"SiteHeader","sourcePath":"ui_kits/site/SiteHeader.jsx"},{"name":"WritingPage","sourcePath":"ui_kits/site/WritingPage.jsx"}],"sourceHashes":{"components/display/Badge.jsx":"115b0f15e9bd","components/display/Card.jsx":"0116a99d319c","components/display/Tag.jsx":"399731361b70","components/forms/Button.jsx":"da4b1cdaf0b8","components/forms/Input.jsx":"ccd4bd315985","components/media/Figure.jsx":"98d7c5782e16","components/media/Rule.jsx":"9ef03b47befe","components/technical/Callout.jsx":"6e1d07f765b6","components/technical/Checklist.jsx":"d57b473c565f","components/technical/CodeBlock.jsx":"9a6fcf330fe8","ui_kits/site/HomePage.jsx":"fa79fbdf7980","ui_kits/site/PostPage.jsx":"c30272727592","ui_kits/site/ProjectsPage.jsx":"cc367e078bca","ui_kits/site/ResumePage.jsx":"66c315be09c9","ui_kits/site/SiteFooter.jsx":"55a004e9b974","ui_kits/site/SiteHeader.jsx":"62c37dadd605","ui_kits/site/WritingPage.jsx":"13c1db8993bf"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.JonDevBrDesignSystem_570ab3 = window.JonDevBrDesignSystem_570ab3 || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// components/display/Badge.jsx
try { (() => {
function Badge({
  status = "neutral",
  dot = true,
  children,
  className = "",
  style
}) {
  return /*#__PURE__*/React.createElement("span", {
    className: `ds-badge ds-badge--${status}` + (className ? " " + className : ""),
    style: style
  }, dot && /*#__PURE__*/React.createElement("span", {
    className: "ds-badge__dot",
    "aria-hidden": "true"
  }), children);
}
Object.assign(__ds_scope, { Badge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/display/Badge.jsx", error: String((e && e.message) || e) }); }

// components/display/Card.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
function Card({
  href,
  onClick,
  interactive,
  padded = true,
  children,
  className = "",
  style,
  ...rest
}) {
  const isInteractive = interactive !== undefined ? interactive : !!(href || onClick);
  const Cmp = href ? "a" : "div";
  const cls = "ds-card" + (padded ? " ds-card--pad" : "") + (isInteractive ? " ds-card--interactive" : "") + (className ? " " + className : "");
  return /*#__PURE__*/React.createElement(Cmp, _extends({
    className: cls,
    href: href,
    onClick: onClick,
    style: style
  }, rest), children);
}
Object.assign(__ds_scope, { Card });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/display/Card.jsx", error: String((e && e.message) || e) }); }

// components/display/Tag.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
function Tag({
  href,
  onClick,
  children,
  className = "",
  style,
  ...rest
}) {
  const interactive = !!(href || onClick);
  const Cmp = href ? "a" : onClick ? "button" : "span";
  const cls = "ds-tag" + (interactive ? " ds-tag--interactive" : "") + (className ? " " + className : "");
  return /*#__PURE__*/React.createElement(Cmp, _extends({
    className: cls,
    href: href,
    onClick: onClick,
    type: Cmp === "button" ? "button" : undefined,
    style: style
  }, rest), children);
}
Object.assign(__ds_scope, { Tag });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/display/Tag.jsx", error: String((e && e.message) || e) }); }

// components/forms/Button.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
function Button({
  variant = "primary",
  size = "md",
  href,
  disabled = false,
  type = "button",
  onClick,
  children,
  className = "",
  style,
  ...rest
}) {
  const cls = `ds-btn ds-btn--${variant} ds-btn--${size}` + (disabled ? " ds-btn--disabled" : "") + (className ? " " + className : "");
  if (href && !disabled) {
    return /*#__PURE__*/React.createElement("a", _extends({
      className: cls,
      href: href,
      onClick: onClick,
      style: style
    }, rest), children);
  }
  return /*#__PURE__*/React.createElement("button", _extends({
    className: cls,
    type: type,
    disabled: disabled,
    onClick: onClick,
    style: style
  }, rest), children);
}
Object.assign(__ds_scope, { Button });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Button.jsx", error: String((e && e.message) || e) }); }

// components/forms/Input.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
function Input({
  label,
  hint,
  error,
  multiline = false,
  rows = 4,
  id,
  className = "",
  style,
  ...rest
}) {
  const autoId = React.useId();
  const inputId = id || autoId;
  const Field = multiline ? "textarea" : "input";
  return /*#__PURE__*/React.createElement("div", {
    className: "ds-field" + (error ? " ds-field--invalid" : "") + (className ? " " + className : ""),
    style: style
  }, label && /*#__PURE__*/React.createElement("label", {
    className: "ds-field__label",
    htmlFor: inputId
  }, label), /*#__PURE__*/React.createElement(Field, _extends({
    className: "ds-input",
    id: inputId,
    rows: multiline ? rows : undefined
  }, rest)), (error || hint) && /*#__PURE__*/React.createElement("div", {
    className: "ds-field__hint" + (error ? " ds-field__hint--error" : "")
  }, error || hint));
}
Object.assign(__ds_scope, { Input });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Input.jsx", error: String((e && e.message) || e) }); }

// components/media/Figure.jsx
try { (() => {
function Figure({
  src,
  alt = "",
  caption,
  meta,
  ratio = "3 / 2",
  placeholderLabel = "photo",
  className = "",
  style
}) {
  return /*#__PURE__*/React.createElement("figure", {
    className: "ds-figure" + (className ? " " + className : ""),
    style: style
  }, /*#__PURE__*/React.createElement("div", {
    className: "ds-figure__frame",
    style: {
      aspectRatio: ratio
    }
  }, src ? /*#__PURE__*/React.createElement("img", {
    src: src,
    alt: alt
  }) : /*#__PURE__*/React.createElement("div", {
    className: "ds-figure__ph"
  }, placeholderLabel)), (caption || meta) && /*#__PURE__*/React.createElement("figcaption", {
    className: "ds-figure__cap"
  }, /*#__PURE__*/React.createElement("span", null, caption), meta && /*#__PURE__*/React.createElement("span", {
    className: "ds-figure__meta"
  }, meta)));
}
Object.assign(__ds_scope, { Figure });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/media/Figure.jsx", error: String((e && e.message) || e) }); }

// components/media/Rule.jsx
try { (() => {
function Rule({
  number,
  label,
  variant = "line",
  className = "",
  style
}) {
  const cls = "ds-rule" + (variant === "double" ? " ds-rule--double" : "") + (className ? " " + className : "");
  return /*#__PURE__*/React.createElement("div", {
    className: cls,
    role: "separator",
    style: style
  }, number && /*#__PURE__*/React.createElement("span", {
    className: "ds-rule__num"
  }, "\xA7 ", number), label && /*#__PURE__*/React.createElement("span", {
    className: "ds-rule__label"
  }, label));
}
Object.assign(__ds_scope, { Rule });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/media/Rule.jsx", error: String((e && e.message) || e) }); }

// components/technical/Callout.jsx
try { (() => {
function Callout({
  level = "note",
  label,
  children,
  className = "",
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    className: `ds-callout ds-callout--${level}` + (className ? " " + className : ""),
    style: style,
    role: level === "warning" ? "alert" : "note"
  }, /*#__PURE__*/React.createElement("span", {
    className: "ds-callout__level"
  }, label || level), /*#__PURE__*/React.createElement("div", {
    className: "ds-callout__body"
  }, children));
}
Object.assign(__ds_scope, { Callout });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/technical/Callout.jsx", error: String((e && e.message) || e) }); }

// components/technical/Checklist.jsx
try { (() => {
function Checklist({
  items = [],
  numbered = true,
  className = "",
  style
}) {
  return /*#__PURE__*/React.createElement("ol", {
    className: "ds-checklist" + (className ? " " + className : ""),
    style: style
  }, items.map((it, i) => /*#__PURE__*/React.createElement("li", {
    key: i,
    className: "ds-checklist__item"
  }, numbered && /*#__PURE__*/React.createElement("span", {
    className: "ds-checklist__num"
  }, String(i + 1).padStart(2, "0")), /*#__PURE__*/React.createElement("span", {
    className: "ds-checklist__label"
  }, it.label), /*#__PURE__*/React.createElement("span", {
    className: "ds-checklist__leader",
    "aria-hidden": "true"
  }), /*#__PURE__*/React.createElement("span", {
    className: "ds-checklist__value ds-checklist__value--" + (it.status || "ok")
  }, it.value))));
}
Object.assign(__ds_scope, { Checklist });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/technical/Checklist.jsx", error: String((e && e.message) || e) }); }

// components/technical/CodeBlock.jsx
try { (() => {
const TOKEN_RE = /(#.*)|("(?:[^"\\]|\\.)*"?|'(?:[^'\\]|\\.)*'?)|(\b(?:def|class|return|import|from|as|if|elif|else|for|while|with|try|except|finally|raise|lambda|pass|yield|async|await|None|True|False|and|or|not|in|is)\b)/g;
function renderLine(line, i) {
  const out = [];
  let key = 0;
  let rest = line;
  const promptMatch = rest.match(/^(>>>|\.\.\.)\s?/);
  if (promptMatch) {
    out.push(/*#__PURE__*/React.createElement("span", {
      className: "ds-code__prompt",
      key: "p" + key++
    }, promptMatch[0]));
    rest = rest.slice(promptMatch[0].length);
  }
  let last = 0;
  let m;
  TOKEN_RE.lastIndex = 0;
  while (m = TOKEN_RE.exec(rest)) {
    if (m.index > last) out.push(rest.slice(last, m.index));
    const cls = m[1] ? "ds-code__comment" : m[2] ? "ds-code__str" : "ds-code__kw";
    out.push(/*#__PURE__*/React.createElement("span", {
      className: cls,
      key: key++
    }, m[0]));
    last = m.index + m[0].length;
  }
  if (last < rest.length) out.push(rest.slice(last));
  return /*#__PURE__*/React.createElement("div", {
    key: i,
    className: "ds-code__line"
  }, out.length ? out : "\u00A0");
}
function CodeBlock({
  title,
  lang = "python",
  code = "",
  highlight = true,
  className = "",
  style
}) {
  const lines = String(code).replace(/\n$/, "").split("\n");
  return /*#__PURE__*/React.createElement("figure", {
    className: "ds-code" + (className ? " " + className : ""),
    style: style
  }, (title || lang) && /*#__PURE__*/React.createElement("figcaption", {
    className: "ds-code__bar"
  }, /*#__PURE__*/React.createElement("span", {
    className: "ds-code__title"
  }, title || "\u00A0"), /*#__PURE__*/React.createElement("span", {
    className: "ds-code__lang"
  }, lang)), /*#__PURE__*/React.createElement("pre", null, highlight ? lines.map(renderLine) : code));
}
Object.assign(__ds_scope, { CodeBlock });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/technical/CodeBlock.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/HomePage.jsx
try { (() => {
const PROJECTS = [{
  name: "queue-pilot",
  desc: "Retry & backoff orchestration for Python workers. Two of everything.",
  tags: ["python", "redis"],
  status: "ok",
  statusLabel: "operational"
}, {
  name: "flightlog",
  desc: "Spotting log + EXIF pipeline for aviation photography.",
  tags: ["python", "exif"],
  status: "ok",
  statusLabel: "operational"
}, {
  name: "steptrack",
  desc: "A MIDI step sequencer that lives in the terminal.",
  tags: ["python", "midi"],
  status: "caution",
  statusLabel: "maintenance"
}];
const POSTS = [{
  title: "preflight checklists for deploys",
  date: "2026-06-18"
}, {
  title: "two of everything: redundancy on a budget",
  date: "2026-05-02"
}, {
  title: "the boring stack: why i still choose postgres",
  date: "2026-03-21"
}];
function HomePage({
  onNav = () => {}
}) {
  const {
    Button,
    Card,
    Tag,
    Badge,
    Rule
  } = window.JonDevBrDesignSystem_570ab3;
  return /*#__PURE__*/React.createElement("main", {
    className: "site-page",
    "data-screen-label": "Home"
  }, /*#__PURE__*/React.createElement("section", {
    className: "home-hero"
  }, /*#__PURE__*/React.createElement("p", {
    className: "site-label"
  }, "backend developer \u2014 brazil \xB7 gmt\u22123"), /*#__PURE__*/React.createElement("h1", {
    className: "home-hero__title"
  }, /*#__PURE__*/React.createElement("span", {
    className: "home-hero__prompt"
  }, ">>>"), " hi, i'm jon."), /*#__PURE__*/React.createElement("p", {
    className: "home-hero__sub"
  }, "I build boring, reliable backend systems in Python \u2014 the kind that page nobody at 3 a.m. Off hours I photograph airplanes and make music with step sequencers."), /*#__PURE__*/React.createElement("div", {
    className: "home-hero__actions"
  }, /*#__PURE__*/React.createElement(Button, {
    onClick: () => onNav("writing")
  }, "Read the blog"), /*#__PURE__*/React.createElement(Button, {
    variant: "secondary",
    onClick: () => onNav("resume")
  }, "View resume"))), /*#__PURE__*/React.createElement("section", {
    className: "site-section"
  }, /*#__PURE__*/React.createElement(Rule, {
    number: "01",
    label: "selected projects"
  }), /*#__PURE__*/React.createElement("div", {
    className: "home-projects"
  }, PROJECTS.map(p => /*#__PURE__*/React.createElement(Card, {
    key: p.name,
    onClick: () => onNav("projects")
  }, /*#__PURE__*/React.createElement("div", {
    className: "home-project__head"
  }, /*#__PURE__*/React.createElement("h3", {
    className: "home-project__name"
  }, p.name), /*#__PURE__*/React.createElement(Badge, {
    status: p.status
  }, p.statusLabel)), /*#__PURE__*/React.createElement("p", {
    className: "home-project__desc"
  }, p.desc), /*#__PURE__*/React.createElement("div", {
    className: "site-tags"
  }, p.tags.map(t => /*#__PURE__*/React.createElement(Tag, {
    key: t
  }, t))))))), /*#__PURE__*/React.createElement("section", {
    className: "site-section"
  }, /*#__PURE__*/React.createElement(Rule, {
    number: "02",
    label: "recent writing"
  }), /*#__PURE__*/React.createElement("div", {
    className: "post-list"
  }, POSTS.map(p => /*#__PURE__*/React.createElement("button", {
    key: p.title,
    type: "button",
    className: "post-row",
    onClick: () => onNav("post")
  }, /*#__PURE__*/React.createElement("span", {
    className: "post-row__title"
  }, p.title), /*#__PURE__*/React.createElement("span", {
    className: "post-row__leader",
    "aria-hidden": "true"
  }), /*#__PURE__*/React.createElement("span", {
    className: "post-row__date"
  }, p.date)))), /*#__PURE__*/React.createElement("div", {
    className: "site-more"
  }, /*#__PURE__*/React.createElement("a", {
    href: "#writing",
    onClick: e => {
      e.preventDefault();
      onNav("writing");
    }
  }, "all posts \u2192"))), /*#__PURE__*/React.createElement("section", {
    className: "site-section"
  }, /*#__PURE__*/React.createElement(Rule, {
    number: "03",
    label: "elsewhere"
  }), /*#__PURE__*/React.createElement("p", {
    className: "home-elsewhere"
  }, /*#__PURE__*/React.createElement("a", {
    href: "#github"
  }, "github \u2197"), " \xB7 ", /*#__PURE__*/React.createElement("a", {
    href: "#photos"
  }, "photos \u2197"), " \xB7 ", /*#__PURE__*/React.createElement("a", {
    href: "#music"
  }, "music \u2197"), " \xB7 ", /*#__PURE__*/React.createElement("a", {
    href: "#mail"
  }, "jon@jon.dev.br"))));
}
Object.assign(__ds_scope, { HomePage });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/HomePage.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/PostPage.jsx
try { (() => {
const CODE = `def deploy(service):
    # run the checklist first, always
    checklist = load("preflight.yaml")
    for item in checklist:
        assert item.verified, item.name
    release(service, canary=True)`;
function PostPage({
  onBack = () => {}
}) {
  const {
    Tag,
    Rule,
    CodeBlock,
    Callout,
    Figure
  } = window.JonDevBrDesignSystem_570ab3;
  return /*#__PURE__*/React.createElement("main", {
    className: "site-page",
    "data-screen-label": "Post"
  }, /*#__PURE__*/React.createElement("article", {
    className: "post"
  }, /*#__PURE__*/React.createElement("p", {
    className: "post__back"
  }, /*#__PURE__*/React.createElement("a", {
    href: "#writing",
    onClick: e => {
      e.preventDefault();
      onBack();
    }
  }, "\u2190 ~/writing")), /*#__PURE__*/React.createElement("h1", {
    className: "post__title"
  }, "preflight checklists for deploys"), /*#__PURE__*/React.createElement("p", {
    className: "post__meta"
  }, "2026-06-18 \xB7 7 min \xB7 ", /*#__PURE__*/React.createElement("span", {
    className: "post__meta-tags"
  }, "ops, aviation")), /*#__PURE__*/React.createElement("p", null, "Aviation solved a problem software still argues about: how do you make a routine, dangerous operation boring? Not with heroics \u2014 with a laminated card and the discipline to read it out loud every single time."), /*#__PURE__*/React.createElement("p", null, "A deploy is a short final approach. You've done it a hundred times, the weather is fine, and that is exactly when confidence does the damage. The checklist doesn't trust your mood, and that's the point."), /*#__PURE__*/React.createElement(CodeBlock, {
    title: "deploy.py",
    code: CODE
  }), /*#__PURE__*/React.createElement("p", null, "The ", /*#__PURE__*/React.createElement("code", null, "assert"), " is deliberate. A checklist that can be skipped is a decoration. Gate the release on it and the discipline stops being optional \u2014 redundancy in the process, not just the infrastructure."), /*#__PURE__*/React.createElement(Callout, {
    level: "caution"
  }, "A checklist longer than ten items stops being read and starts being scrolled. Cut it until it hurts."), /*#__PURE__*/React.createElement("p", null, "Pilots call it ", /*#__PURE__*/React.createElement("em", null, "aviate, navigate, communicate"), " \u2014 priority order for when things go wrong. Ours is roughly: stop the bleeding, restore service, then write the postmortem. Same idea. The order matters more than the speed."), /*#__PURE__*/React.createElement(Figure, {
    caption: "PA-28 short final, rwy 21 \u2014 the original deploy pipeline",
    meta: "200mm \xB7 f/5.6 \xB7 1/1000",
    ratio: "16 / 9",
    placeholderLabel: "photo \u2014 awaiting scan"
  }), /*#__PURE__*/React.createElement("div", {
    className: "post__foot"
  }, /*#__PURE__*/React.createElement(Rule, {
    variant: "double"
  }), /*#__PURE__*/React.createElement("div", {
    className: "post__filed"
  }, /*#__PURE__*/React.createElement("span", {
    className: "site-label"
  }, "filed under"), /*#__PURE__*/React.createElement("span", {
    className: "site-tags"
  }, /*#__PURE__*/React.createElement(Tag, null, "ops"), /*#__PURE__*/React.createElement(Tag, null, "aviation"))))));
}
Object.assign(__ds_scope, { PostPage });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/PostPage.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/ProjectsPage.jsx
try { (() => {
const PROJECTS = [{
  name: "queue-pilot",
  year: "2024—",
  desc: "Retry & backoff orchestration for Python workers. Dead-letter queues, jittered backoff, and a status board. Two of everything.",
  tags: ["python", "redis", "rabbitmq"],
  status: "ok",
  statusLabel: "operational"
}, {
  name: "flightlog",
  year: "2023—",
  desc: "Spotting log + EXIF pipeline for aviation photography. Reads a card full of RAWs, files them by registration and runway.",
  tags: ["python", "exif", "sqlite"],
  status: "ok",
  statusLabel: "operational"
}, {
  name: "steptrack",
  year: "2022—",
  desc: "A MIDI step sequencer that lives in the terminal. 16 steps, 4 tracks, zero dependencies.",
  tags: ["python", "midi", "curses"],
  status: "caution",
  statusLabel: "maintenance"
}, {
  name: "checkdeck",
  year: "2021—2023",
  desc: "Preflight checklists as code. YAML in, discipline out. Superseded by queue-pilot's gate step.",
  tags: ["python", "yaml"],
  status: "neutral",
  statusLabel: "archived"
}];
function ProjectsPage() {
  const {
    Card,
    Tag,
    Badge,
    Rule
  } = window.JonDevBrDesignSystem_570ab3;
  return /*#__PURE__*/React.createElement("main", {
    className: "site-page",
    "data-screen-label": "Projects"
  }, /*#__PURE__*/React.createElement("p", {
    className: "site-label"
  }, "~/projects"), /*#__PURE__*/React.createElement("h1", {
    className: "site-title"
  }, "projects"), /*#__PURE__*/React.createElement("p", {
    className: "site-intro"
  }, "Small tools, maintained like aircraft: inspected regularly, retired honestly."), /*#__PURE__*/React.createElement("section", {
    className: "site-section"
  }, /*#__PURE__*/React.createElement(Rule, {
    number: "01",
    label: "registry"
  }), /*#__PURE__*/React.createElement("div", {
    className: "projects-list"
  }, PROJECTS.map(p => /*#__PURE__*/React.createElement(Card, {
    key: p.name,
    href: "#",
    onClick: e => e.preventDefault()
  }, /*#__PURE__*/React.createElement("div", {
    className: "project-row"
  }, /*#__PURE__*/React.createElement("div", {
    className: "project-row__main"
  }, /*#__PURE__*/React.createElement("div", {
    className: "project-row__head"
  }, /*#__PURE__*/React.createElement("h3", {
    className: "project-row__name"
  }, p.name, " ", /*#__PURE__*/React.createElement("span", {
    className: "project-row__ext"
  }, "\u2197")), /*#__PURE__*/React.createElement("span", {
    className: "project-row__year"
  }, p.year)), /*#__PURE__*/React.createElement("p", {
    className: "project-row__desc"
  }, p.desc), /*#__PURE__*/React.createElement("div", {
    className: "site-tags"
  }, p.tags.map(t => /*#__PURE__*/React.createElement(Tag, {
    key: t
  }, t)))), /*#__PURE__*/React.createElement(Badge, {
    status: p.status
  }, p.statusLabel)))))));
}
Object.assign(__ds_scope, { ProjectsPage });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/ProjectsPage.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/ResumePage.jsx
try { (() => {
const EXPERIENCE = [{
  role: "senior backend engineer",
  org: "cargolog systems",
  dates: "2022 — now",
  bullets: ["Own the dispatch queue platform: Python, Postgres, Redis; 40M jobs/day.", "Cut p99 job latency 6× by replacing polling with fanout + backpressure.", "Wrote the deploy preflight checklist now gating every production release."]
}, {
  role: "backend engineer",
  org: "verde pagamentos",
  dates: "2019 — 2022",
  bullets: ["Built idempotent payment webhooks (exactly-once effects, at-least-once delivery).", "On-call rotation lead; halved pages by deleting alerts nobody acted on."]
}, {
  role: "developer",
  org: "freelance",
  dates: "2016 — 2019",
  bullets: ["Django & Flask backends for local businesses; hosting, backups, the works."]
}];
const SKILLS = [{
  group: "languages",
  items: ["python", "sql", "bash"]
}, {
  group: "infrastructure",
  items: ["postgres", "redis", "rabbitmq", "docker", "aws"]
}, {
  group: "practices",
  items: ["observability", "incident response", "ci/cd", "load testing"]
}];
function ResumePage() {
  const {
    Button,
    Tag,
    Rule,
    Checklist
  } = window.JonDevBrDesignSystem_570ab3;
  return /*#__PURE__*/React.createElement("main", {
    className: "site-page site-page--narrow",
    "data-screen-label": "Resume"
  }, /*#__PURE__*/React.createElement("div", {
    className: "resume-head"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("p", {
    className: "site-label"
  }, "~/resume"), /*#__PURE__*/React.createElement("h1", {
    className: "site-title"
  }, "jon"), /*#__PURE__*/React.createElement("p", {
    className: "resume-contact"
  }, "backend developer \xB7 s\xE3o paulo, br \xB7 jon@jon.dev.br \xB7 github.com/jon")), /*#__PURE__*/React.createElement(Button, {
    variant: "secondary",
    size: "sm",
    onClick: () => window.print()
  }, "Print / PDF")), /*#__PURE__*/React.createElement("section", {
    className: "site-section"
  }, /*#__PURE__*/React.createElement(Rule, {
    number: "01",
    label: "experience"
  }), EXPERIENCE.map(e => /*#__PURE__*/React.createElement("div", {
    key: e.org,
    className: "resume-entry"
  }, /*#__PURE__*/React.createElement("div", {
    className: "resume-entry__head"
  }, /*#__PURE__*/React.createElement("h3", {
    className: "resume-entry__role"
  }, e.role, " ", /*#__PURE__*/React.createElement("span", {
    className: "resume-entry__org"
  }, "@ ", e.org)), /*#__PURE__*/React.createElement("span", {
    className: "resume-entry__leader",
    "aria-hidden": "true"
  }), /*#__PURE__*/React.createElement("span", {
    className: "resume-entry__dates"
  }, e.dates)), /*#__PURE__*/React.createElement("ul", {
    className: "resume-entry__bullets"
  }, e.bullets.map((b, i) => /*#__PURE__*/React.createElement("li", {
    key: i
  }, b)))))), /*#__PURE__*/React.createElement("section", {
    className: "site-section"
  }, /*#__PURE__*/React.createElement(Rule, {
    number: "02",
    label: "skills"
  }), SKILLS.map(s => /*#__PURE__*/React.createElement("div", {
    key: s.group,
    className: "resume-skills"
  }, /*#__PURE__*/React.createElement("span", {
    className: "site-label"
  }, s.group), /*#__PURE__*/React.createElement("span", {
    className: "site-tags"
  }, s.items.map(t => /*#__PURE__*/React.createElement(Tag, {
    key: t
  }, t)))))), /*#__PURE__*/React.createElement("section", {
    className: "site-section"
  }, /*#__PURE__*/React.createElement(Rule, {
    number: "03",
    label: "education & certificates"
  }), /*#__PURE__*/React.createElement(Checklist, {
    numbered: false,
    items: [{
      label: "b.sc. computer science — ufsc",
      value: "2016"
    }, {
      label: "private pilot ground school",
      value: "in progress",
      status: "pending"
    }]
  })));
}
Object.assign(__ds_scope, { ResumePage });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/ResumePage.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/SiteFooter.jsx
try { (() => {
function SiteFooter() {
  const {
    Badge
  } = window.JonDevBrDesignSystem_570ab3;
  return /*#__PURE__*/React.createElement("footer", {
    className: "site-footer"
  }, /*#__PURE__*/React.createElement("div", {
    className: "site-footer__in"
  }, /*#__PURE__*/React.createElement("div", {
    className: "site-footer__rule"
  }), /*#__PURE__*/React.createElement("div", {
    className: "site-footer__row"
  }, /*#__PURE__*/React.createElement("span", {
    className: "site-footer__note"
  }, "built with the basic that works. \xA9 2026"), /*#__PURE__*/React.createElement(Badge, {
    status: "ok"
  }, "all systems normal"))));
}
Object.assign(__ds_scope, { SiteFooter });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/SiteFooter.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/SiteHeader.jsx
try { (() => {
const NAV = [{
  id: "home",
  label: "~"
}, {
  id: "writing",
  label: "writing"
}, {
  id: "projects",
  label: "projects"
}, {
  id: "resume",
  label: "resume"
}];
function SiteHeader({
  route = "home",
  onNav = () => {}
}) {
  return /*#__PURE__*/React.createElement("header", {
    className: "site-header"
  }, /*#__PURE__*/React.createElement("div", {
    className: "site-header__in"
  }, /*#__PURE__*/React.createElement("button", {
    className: "site-wordmark",
    type: "button",
    onClick: () => onNav("home")
  }, /*#__PURE__*/React.createElement("span", {
    className: "site-wordmark__prompt"
  }, ">>>"), " jon.dev.br"), /*#__PURE__*/React.createElement("nav", {
    className: "site-nav",
    "aria-label": "site"
  }, NAV.map(item => {
    const active = route === item.id || item.id === "writing" && route === "post";
    return /*#__PURE__*/React.createElement("button", {
      key: item.id,
      type: "button",
      className: "site-nav__link" + (active ? " site-nav__link--active" : ""),
      onClick: () => onNav(item.id)
    }, item.id === "home" ? "~/" : /*#__PURE__*/React.createElement("span", null, /*#__PURE__*/React.createElement("span", {
      className: "site-nav__slash"
    }, "/"), item.label));
  }))));
}
Object.assign(__ds_scope, { SiteHeader });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/SiteHeader.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/WritingPage.jsx
try { (() => {
const YEARS = [{
  year: "2026",
  posts: [{
    title: "preflight checklists for deploys",
    date: "2026-06-18",
    tags: ["ops", "aviation"]
  }, {
    title: "two of everything: redundancy on a budget",
    date: "2026-05-02",
    tags: ["architecture"]
  }, {
    title: "the boring stack: why i still choose postgres",
    date: "2026-03-21",
    tags: ["python", "postgres"]
  }]
}, {
  year: "2025",
  posts: [{
    title: "shooting film at airshows",
    date: "2025-11-09",
    tags: ["photography", "aviation"]
  }, {
    title: "a step sequencer in 200 lines of python",
    date: "2025-08-14",
    tags: ["music", "python"]
  }, {
    title: "idempotency keys, twice",
    date: "2025-04-03",
    tags: ["architecture", "python"]
  }]
}];
function WritingPage({
  onOpenPost = () => {}
}) {
  const {
    Tag,
    Rule
  } = window.JonDevBrDesignSystem_570ab3;
  return /*#__PURE__*/React.createElement("main", {
    className: "site-page",
    "data-screen-label": "Writing"
  }, /*#__PURE__*/React.createElement("p", {
    className: "site-label"
  }, "~/writing"), /*#__PURE__*/React.createElement("h1", {
    className: "site-title"
  }, "writing"), /*#__PURE__*/React.createElement("p", {
    className: "site-intro"
  }, "Notes on backends, redundancy, and the occasional airplane. Plain text, no tracking."), YEARS.map(y => /*#__PURE__*/React.createElement("section", {
    key: y.year,
    className: "site-section"
  }, /*#__PURE__*/React.createElement(Rule, {
    label: y.year
  }), /*#__PURE__*/React.createElement("div", {
    className: "post-list"
  }, y.posts.map(p => /*#__PURE__*/React.createElement("button", {
    key: p.title,
    type: "button",
    className: "post-row",
    onClick: onOpenPost
  }, /*#__PURE__*/React.createElement("span", {
    className: "post-row__title"
  }, p.title), /*#__PURE__*/React.createElement("span", {
    className: "post-row__tags"
  }, p.tags.map(t => /*#__PURE__*/React.createElement(Tag, {
    key: t
  }, t))), /*#__PURE__*/React.createElement("span", {
    className: "post-row__leader",
    "aria-hidden": "true"
  }), /*#__PURE__*/React.createElement("span", {
    className: "post-row__date"
  }, p.date)))))));
}
Object.assign(__ds_scope, { WritingPage });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/WritingPage.jsx", error: String((e && e.message) || e) }); }

__ds_ns.Badge = __ds_scope.Badge;

__ds_ns.Card = __ds_scope.Card;

__ds_ns.Tag = __ds_scope.Tag;

__ds_ns.Button = __ds_scope.Button;

__ds_ns.Input = __ds_scope.Input;

__ds_ns.Figure = __ds_scope.Figure;

__ds_ns.Rule = __ds_scope.Rule;

__ds_ns.Callout = __ds_scope.Callout;

__ds_ns.Checklist = __ds_scope.Checklist;

__ds_ns.CodeBlock = __ds_scope.CodeBlock;

__ds_ns.HomePage = __ds_scope.HomePage;

__ds_ns.PostPage = __ds_scope.PostPage;

__ds_ns.ProjectsPage = __ds_scope.ProjectsPage;

__ds_ns.ResumePage = __ds_scope.ResumePage;

__ds_ns.SiteFooter = __ds_scope.SiteFooter;

__ds_ns.SiteHeader = __ds_scope.SiteHeader;

__ds_ns.WritingPage = __ds_scope.WritingPage;

})();
