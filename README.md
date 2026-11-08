# blog.jon.dev.br

Bilingual (EN/PT) Jekyll blog, project registry and resume.

## Requirements

Docker and git. Nothing else — Ruby and Jekyll live in the container.

## Before you start: frankmd

`docker-compose.yml` carries a `frankmd` service, a browser editor for the
Markdown under `_posts/`, served on `http://localhost:7591`. It reads its
settings from `.env.frank`, which is git-ignored. Create it once from the
example and fill in the values:

```bash
cp .env.frank.example .env.frank
openssl rand -hex 64   # paste as SECRET_KEY_BASE
id -u; id -g           # UID and GID, so edited files keep your ownership
```

Every `docker compose` command prints a warning that `SECRET_KEY_BASE` is
not set. That is the `environment:` line on the service: Compose expands
`${SECRET_KEY_BASE}` from your shell or a top-level `.env`, never from
`.env.frank`. The warning is harmless for `bin/serve`, `bin/test` and
`bin/build`, which never start frankmd, and the service itself still gets
the value from `.env.frank`. Export the variable in your shell to silence it.

Start it with `docker compose up -d frankmd`. It is not part of `bin/serve`.

## Getting started

```bash
./bin/serve     # http://localhost:4000
./bin/test      # minitest + html-proofer
./bin/build     # full validation, exports _site/
```

See `CLAUDE.md` for the design rules, the post-authoring workflow and the
available Liquid tags.
