# jon.dev.br — design system

Personal site for **jon**, a backend developer in Brazil. The site is a simple blog,
a resume, and a project registry. Interests that shape the brand: **Python**,
**aviation** (safety culture, checklists, redundancy), **photography** (film, airplanes),
and **music making** (step sequencers).

**Design stance:** the basic that works. Minimalist, white, readability first.
Retro — 70s technical manual × terminal computing — but with modern spacing,
contrast, and restraint. Utility and cleverness over decoration.

**Sources:** no codebase, Figma, or asset files were provided. This system was
authored from the written brief only. All site copy, project names, and resume
data in the UI kit are **plausible sample content** — replace with real material.

---

## CONTENT FUNDAMENTALS

- **Voice:** first person ("I build…"), addressing the reader as "you". Short
  declarative sentences. Honest about trade-offs; dry, technical humor.
- **Casing:** headings and nav are lowercase mono ("writing", "hi, i'm jon.").
  Labels/badges/values are uppercase mono, tracked (+0.08em). Prose is normal
  sentence case.
- **Dates:** always ISO 8601 (`2026-07-07`). Separators are `·`.
- **No emoji. No exclamation marks. No hype words** ("passionate", "rockstar", "🚀").
- **Aviation vocabulary is the metaphor bank:** preflight, checklist, short final,
  redundancy, "aviate, navigate, communicate", "two of everything", placards
  (NOTE/CAUTION/WARNING), registries.
- **Python vocabulary:** the `>>>` REPL prompt opens hero lines and section intros;
  paths (`~/writing`) name pages.
- Examples:
  - hero: `>>> hi, i'm jon. i build boring, reliable backends.`
  - status: `all systems normal · last deploy 2026-07-07`
  - error: `404 — this route was decommissioned.`
  - footer: `built with the basic that works. © 2026`

## VISUAL FOUNDATIONS

- **Colors:** warm print-white paper (`--paper-0 #FCFCF8`), green-tinted ink greys,
  and a sea-green ramp (`--green-050…900`). Primary action = `--green-700 #175937`.
  `--green-bright #22A45D` is the phosphor accent (prompt, cursor, live dots) — small
  doses only. Status = aviation placards: ok (green), caution (amber `#7A5200` on
  `#FAF3D7`), warning (red `#9C3025` on `#F9EDE9`). One dark surface exists: the
  terminal (`#0D1F16` with phosphor `#5BD98E`), used only for code.
- **Type:** two faces. **IBM Plex Mono** carries all structure — headings, nav,
  labels, buttons, checklist rows, code, metadata. **IBM Plex Serif** carries prose
  only (17px/1.75, measure 680px). Scale 11→42px; labels 11px 500 uppercase +0.08em.
- **Spacing:** 4px base (`--sp-1…9`: 4→96). Shell 1080px; prose 680px.
- **Backgrounds:** flat paper. No gradients, no textures, no full-bleed imagery.
  Insets use `--paper-1`; the crosshatch placeholder pattern marks missing photos.
- **Borders:** 1px hairlines everywhere (`--line-1`); `--line-2` for emphasis.
  Dotted = leaders. Dashed = annotation. 3px double rule closes a page (retro doc).
- **Radii:** near-square — 2px on buttons/inputs/tags/cards; 4px on terminal panels
  and dialogs. Nothing pill-shaped except nothing.
- **Elevation:** flat by default; **no soft shadows on cards.** Interactive cards
  lift with translate(-2px,-2px) + hard offset shadow `4px 4px 0 --line-1` (retro
  print). `--shadow-pop` (soft) is reserved for dialogs/popovers.
- **Hover:** color-based — green-050 background tint, text to green-800, borders to
  green. Links underline green always. **Press:** buttons nudge down 1px; cards
  flatten back.
- **Motion:** 120ms (color/border) and 180ms (lifts), single ease-out
  cubic-bezier(.2,.7,.3,1). No bounces, no parallax, no infinite loops (exception:
  the wordmark cursor blink, steps(1)). Respect prefers-reduced-motion.
- **Imagery:** photography only (airplanes, film) in `Figure` frames — white mat,
  hairline border, mono EXIF caption. Never illustrate; never generate. No image →
  crosshatch placeholder.
- **Transparency/blur:** none. Solid paper surfaces only.

## ICONOGRAPHY

- **No icon font, no SVG icon set.** Iconography is **typographic**: unicode glyphs
  from the mono face — `→` follow, `↗` external, `←` back, `▸` expand, `✓` done,
  `×` close/fail, `●`/`○` status, `§` section, `#` tag, `~` home, `/` path,
  `@` contact, `▮` cursor, `·` separator, `>>>` prompt. See `guidelines/brand-glyphs.html`.
- Glyphs are always paired with a text label in buttons/links (never icon-only).
- **No logo exists.** The wordmark is plain type: `>>> jon.dev.br` (prompt in
  phosphor green, optional blinking cursor). Do not draw a mark.
- If a real pictographic icon is ever unavoidable, use Lucide (CDN) at 1.5px stroke,
  16–18px — and flag it as a substitution.

## INDEX

- `styles.css` — global entry; imports everything below.
- `tokens/` — `fonts.css` (Google Fonts: IBM Plex Mono + Serif — **substitution**,
  no binaries provided), `colors.css`, `typography.css`, `spacing.css`,
  `effects.css`, `base.css` (element defaults).
- `components/components.css` — all `ds-*` component styles.
- **Components** (React, `window.JonDevBrDesignSystem_570ab3`):
  - `components/forms/` — **Button**, **Input**
  - `components/display/` — **Tag**, **Badge**, **Card**
  - `components/technical/` — **CodeBlock**, **Callout**, **Checklist**
  - `components/media/` — **Figure**, **Rule**
  - Each has `.d.ts` (props) and `.prompt.md` (usage).
- `guidelines/` — 16 specimen cards (Colors / Type / Layout / Brand groups).
- `ui_kits/site/` — interactive recreation of the full site: Home, Writing, Post,
  Projects, Resume (`index.html` + one JSX per screen). See its README.
- `assets/` — **empty by design**: no logo/photos were provided; type-only wordmark,
  crosshatch photo placeholders.
- `SKILL.md` — agent skill entry point.

## INTENTIONAL ADDITIONS

No source defined a component inventory, so a standard set was authored, sized to a
blog/resume/projects portfolio. Beyond generic primitives, four are brand-specific:
**Checklist** (dotted-leader preflight rows), **Callout** (NOTE/CAUTION/WARNING
placards), **CodeBlock** (Python REPL terminal), **Figure** (EXIF photo frame).
Skipped as unneeded for this site: Select, Switch, Tabs, Dialog, Toast, Tooltip, Avatar.

## CAVEATS

- Fonts load from Google Fonts CDN; self-hosted binaries not included.
- All names, employers, posts, and project READMEs are sample copy.
- No photography assets yet — `Figure` shows placeholders until real scans arrive.
