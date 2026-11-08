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

`.env.frank` is the only place the service reads these values from; nothing
in `docker-compose.yml` repeats them.

Start it with `docker compose up -d frankmd`. It is not part of `bin/serve`.

## Getting started

```bash
./bin/serve     # http://localhost:4000
./bin/test      # minitest + html-proofer
./bin/build     # full validation, exports _site/
```

See `CLAUDE.md` for the design rules, the post-authoring workflow and the
available Liquid tags.
