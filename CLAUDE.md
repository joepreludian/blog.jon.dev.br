# jon.dev.br — working rules

A bilingual (EN/PT) Jekyll blog, project registry and resume. The theme is an
implementation of a design that already exists — read the next section before
changing anything visual.

## Identity — confirm before deploy

`_config.yml` carries three identity values. Only one is confirmed:

| Key | Value | Status |
| --- | --- | --- |
| `email` | `me@jon.dev.br` | **Confirmed real address.** Flows into both Atom feeds (`<email>`) and the footer `mailto:` link. |
| `url` | `https://blog.jon.dev.br` | **Placeholder, invented by the plan. Must be confirmed before the first deploy.** |
| `github` | `https://github.com/jondevbr` | **Placeholder, invented by the plan. Must be confirmed before the first deploy.** |

`url` is not cosmetic: it bakes into every absolute URL the site emits —
both feeds' `<link>`/`id` elements, every hreflang alternate
(`test_hreflang_alternates_are_reciprocal` builds its expected URLs from
`site.config["url"]`), and `sitemap.xml`. Deploying with the wrong `url` means
every one of those is silently wrong, not obviously broken. Confirm it (and
`github`, which only appears in on-page links) before the first real deploy.

## Sample content — rewrite or delete before publishing

Every post currently in `_posts/` is placeholder copy ported from
`docs/_reference_design/` (or, for `two-of-everything`, written to exercise it)
and is **not** something this author wrote. Each one carries `sample: true` in
its front matter as a marker for the author — it is metadata only, not a
visible badge or banner, and has no effect on rendering.

- `_posts/{en,pt}/2026-07-21-two-of-everything.md` — also structurally
  lopsided, not just placeholder voice: the PT file is missing the code,
  mermaid and closing blocks the EN file has, because Tasks 10–13 each
  appended a demonstration block to the EN file only while exercising their
  tag. If you are editing this pair rather than deleting it, do not treat the
  EN file as a translation source for the PT one — they diverged in
  structure, not just language.
- `_posts/{en,pt}/2026-07-02-idempotency-keys.md`
- `_posts/{en,pt}/2026-06-14-reading-the-black-box.md`
- `_posts/{en,pt}/2026-05-30-step-sequencer-python.md`
- `_posts/{en,pt}/2026-05-11-film-grain-log-files.md`

Before this blog goes live under the author's name: rewrite each pair with
real content, or delete the pair (both languages, together — `SiteBuildTest`
fails the build on an unpaired post). `sample: true` is not read by any layout
or plugin; removing it is optional, but there is no reason to ship it.

## The design is not yours to invent

`docs/_reference_design/` is the source of truth and is excluded from the build.

- `jon.dev.br Blog.dc.html` — the reference layout: home and post screens, the
  shell, the EN/PT toggle, the post block types, and the orange token
  overrides. **This file wins** where it and the readme disagree.
- `_ds/…/readme.md` — the design brief: voice, casing, palette intent, type,
  borders, motion, iconography.
- `support.js` and `_ds_bundle.js` are the Design Composer runtime. Not ported,
  reference only.

`/projects` and `/resume` are not in the reference. They were composed from
existing `ds-*` components and the brief's vocabulary. Extend them the same
way: no new visual language.

### Non-negotiable rules

- Headings and nav are **lowercase mono**. Labels, badges and buttons are
  **uppercase mono, `letter-spacing: 0.08em`**. Prose is sentence-case serif.
- IBM Plex Mono carries all structure. IBM Plex Serif carries prose only.
- Dates are **ISO 8601**. Metadata separator is `·`.
- **No emoji. No exclamation marks. No hype words.**
- Iconography is typographic only: `→ ↗ ← ▸ ✓ × ● ○ § # ~ / @ ▮ · >>>`. No icon
  font, no SVG icon set, no logo. Glyphs always carry a text label.
- Flat surfaces. No gradients, no textures, no blur, **no soft shadows on
  cards**. Interactive cards lift with `translate(-2px, -2px)` plus
  `4px 4px 0 0 var(--line-1)`.
- Radii are `0`.
- Motion is 120ms (colour) or 180ms (lifts), `cubic-bezier(.2,.7,.3,1)`.
  `prefers-reduced-motion` kills all of it. The only loop is the wordmark
  cursor blink, `steps(1)`.
- Photography only, in `figure`. Never illustrate, never generate. No image
  means the crosshatch placeholder.
- **Never invent a metric.** The reference hero carries `uptime 99.98%`; it is
  deliberately absent here because nothing measures it. `last deploy` is real
  (the build timestamp). The `all systems normal` placard is static brand copy.

The accent ramp is named `--accent-050…900` and `--accent-bright`, not
`--green-*` as in the reference — same values, honest names.

## Commands

**Two interfaces, one rule: `bin/*` outside the container, `rake *` inside.**
Never add a third build path.

| Outside | Does |
| --- | --- |
| `./bin/serve` | Dev server with Compose Watch on `localhost:4000` |
| `./bin/build` | Full `rake ci` then exports `_site` to the host |
| `./bin/test` | Minitest + html-proofer (`--external` adds live link checks) |
| `./bin/lint` | RuboCop |
| `./bin/shell` | Interactive shell in the dev image |
| `./bin/export` | Copies `_site` out of the named volume |

Inside the container: `rake lint`, `rake test`, `rake build`, `rake proof`,
`rake ci`.

`bin/build` runs the whole validation chain because the `export` stage descends
from `ci`. It is not a fast path. `bin/serve` is.

**Always use `./bin/test` and `./bin/lint`, never a raw `docker compose run`.**
Every `bin/*` script that shells out to Compose runs `docker compose build
task` first, explicitly, before `docker compose run`. That is not decoration:
`docker compose run` only builds an image when none exists yet, so after a
source edit with no accompanying rebuild it happily runs the **previous**
version of the code and reports success against it. That exact failure mode —
a raw `docker compose run` producing a false green — happened during this
plan's implementation. If you ever run Compose by hand for debugging, rebuild
first (`docker compose build task`) or you cannot trust the result.

That is a stale **image**. There is a separate, cheaper way to get a stale
**`_site`**: `./bin/test` runs `rake test proof`, and `rake proof` never
invokes `rake build` — so its html-proofer pass checks whatever `_site`
already sits in the `jekyll_site` volume, which may be left over from an
earlier, unrelated `rake build`. `./bin/build` is the only invocation that
runs `lint → test → build → proof` in that order (via `rake ci`), so it is the
only one guaranteed to proof the site you currently have checked out.

## Adding a post

Two files, always. EN and PT are peers, not original and translation.

```
_posts/en/2026-07-21-two-of-everything.md
_posts/pt/2026-07-21-two-of-everything.md
```

Same date, same `ref`. Slugs may differ if a Portuguese slug reads better.

```yaml
---
title: "two of everything: redundancy for a one-person backend"
dek: "What a 1948 flight manual taught me about running production alone."
ref: two-of-everything
tags: [redundancy, ops]
---
```

`lang`, `layout` and `permalink` come from `_config.yml` defaults. The date
comes from the filename. `num` and reading time are computed. Nothing else is
needed, and `SiteBuildTest` fails the build if a pair is incomplete.

`## a heading` renders as `§ 01 a heading` with a trailing hairline, via a CSS
counter. There is no section tag.

## Liquid tags

All take keyword arguments. A missing required attribute fails the build with a
message naming the tag.

```liquid
{% callout level="NOTE" %}Body, rendered as Markdown.{% endcallout %}
{% codeblock lang="python" title="watchdog.py" %}code{% endcodeblock %}
{% mermaid caption="fig 01 — caption" %}flowchart LR
  A --> B{% endmermaid %}
{% youtube id="aqz-KE-bpKQ" caption="demo" %}{% endyoutube %}
{% figure src="/assets/img/x.jpg" alt="…" caption="…" meta="Portra 400 · 50mm" %}{% endfigure %}
```

Callout levels are bilingual: `NOTE`/`NOTA`, `CAUTION`/`CUIDADO`,
`WARNING`/`AVISO`. An unknown level fails the build. An unknown `codeblock`
language only warns and falls back to plain text.

Plain Markdown fences work and get the same terminal surface, without a title
bar.

## Two Liquid traps that will cost you a debugging session

Both have already cost this plan a task each while it was being built. Neither
one raises an error — that is exactly what makes them expensive.

- **A filter chain inside `[...]` renders empty, not nil, not an error.**
  Liquid's bracket lookup does not evaluate a filter chain written inside the
  brackets: `strings[page.lang | default: site.lang]` silently resolves to
  nothing, with no warning anywhere. The fix is always the same — assign the
  resolved key to a local first, then index with the bare variable:
  ```liquid
  {%- assign lang = page.lang | default: site.lang -%}
  {%- assign strings = site.data.strings[lang] -%}
  ```
  See the comment block at the top of `_includes/header.html`, `nav.html` and
  `footer.html`, and the same pattern in `_includes/project-row.html`
  (`strings.projects.status[project.status] | default: project.status`).

- **Liquid drops a block's entire output when `blank?` is true — and that one
  root cause shows up as two unrelated-looking symptoms.** `Liquid::Block`
  decides whether to render at all by asking its own `blank?`, which by
  default means "is the rendered body nothing but whitespace". When it is,
  the parent `BlockBody` silently discards the whole node's output — not a
  trim, a full drop, no warning. Two places in this codebase hit that:
  - **A separator that disappears.** A `{% for %}` or `{% if %}` tag whose
    rendered body is only whitespace/newlines produces no output at all — not
    even the whitespace. This is why the tag separator between entries is
    built with `join: " #"` on an array, rather than looping over tags with
    `{% unless forloop.last %} {% endunless %}` to insert a separator: a
    trailing `{% unless forloop.last %}` whose only content is a space is
    exactly the kind of block Liquid throws away, so the separator silently
    vanishes on the last real render pass, not in a way that fails a test that
    isn't looking for it. See `_includes/entry-row.html`, `_layouts/home.html`
    and `_layouts/post.html`.
  - **A tag that renders nothing because its body is empty.** Every `ds-*`
    block tag (`callout`, `codeblock`, `mermaid`, `youtube`, `figure`)
    extends `Liquid::Block` through `JonDevBr::Tags::Base`, and `youtube` and
    `figure` are legitimately always called with an empty body —
    `{% youtube id="…" %}{% endyoutube %}`. Left at Liquid's default, an
    empty body means `blank?` is `true`, so `BlockBody` would discard the
    tag's entire rendered output — the whole `render_html` result, not just
    the (empty) body — with no error. `_plugins/jon_dev_br/tags/base.rb`
    overrides `blank?` to always return `false`, and every tag gets this for
    free by inheriting from `Base`. If you write a new Liquid block tag here
    and it silently renders nothing with no error, check first whether it
    extends `Base` — this is almost certainly why.

## `sitemap: false` on the feeds and 404 is inert belt-and-braces

`feed.xml`, `pt/feed.xml` and `404.html` all set `sitemap: false` in their
front matter. With **jekyll-sitemap 1.4.0** (pinned in `Gemfile.lock`), that
flag never does any work here: the generator only ever iterates
`site.html_pages`, which already excludes non-`.html` output (so both feed
files are excluded by extension alone, not by the flag), and it hardcodes an
exclusion for any page named `404.html` regardless of front matter. The flag
is kept anyway as belt-and-braces documentation of intent, and because a
future jekyll-sitemap upgrade could change either behaviour — but as of 1.4.0,
deleting it would change nothing.

## Things that will confuse you later

- **`_posts/en/` and `_posts/pt/` make Jekyll assign categories `en` and
  `pt`.** That is a side effect of the directory layout. Categories are ignored
  everywhere in this theme; topics use `tags`. Do not add a category page.
- **Entry numbers are reverse-chronological** — the newest post is `001`, as in
  the reference. A post's number therefore changes when a newer one is
  published. It is display metadata only and never appears in a URL, an
  element id, or a feed id.
- **`--force_polling` is off on purpose.** Compose Watch syncs files into the
  container, where they land as ordinary writes and fire real inotify events.
  Watching across the Colima mount is what does not work; polling was the
  workaround we do not need.
- **`--incremental` is off on purpose.** It goes stale on layout and include
  changes. `.jekyll-cache` is a named volume, which already caches the slow
  work.
- **`_site` and `.jekyll-cache` are named volumes**, not on the host. Use
  `bin/export` when you need the files.
- **UI copy lives in `_data/strings/{en,pt}.yml`.** Both files must carry every
  key — a missing key renders blank with no warning.
- **The Mermaid loader is injected by a hook**, only into documents containing
  `data-mermaid`. Its SRI hash is pinned; changing the Mermaid version means
  recomputing it:
  `curl -sL <url> | openssl dgst -sha384 -binary | openssl base64 -A`

## Recorded follow-ups

Deliberately not built. Each is a small, self-contained addition.

- Self-hosted IBM Plex woff2 subsets, replacing the Google Fonts dependency.
- Tag pages and archive filtering. Tags are display-only today.
- Publishing the build image to GHCR (needs multi-arch: this machine is arm64,
  runners are amd64).
- Mermaid 11 upgrade.
- A PDF resume, if an asset ever exists.

## Conventions

Conventional commits. No "Co-Authored-By" trailers. Never push without asking.
Ruby files carry `# frozen_string_literal: true` and live under `JonDevBr::`,
one concern per file.
