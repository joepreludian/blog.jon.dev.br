# syntax=docker/dockerfile:1

# Base image is pinned by digest for reproducibility.
# To re-pin:
#   docker pull ruby:4.0-slim-trixie
#   docker inspect --format='{{index .RepoDigests 0}}' ruby:4.0-slim-trixie
#
# Ruby 4.0 was verified clean against this Gemfile (jekyll, sass-embedded,
# nokogiri, html-proofer, rubocop and friends) on 2026-07-30: gems installed
# and `bundle exec rake ci` produced the expected _site output with no
# missing-stdlib or native-extension errors, so 4.0 was kept over 3.4.
# Tag: ruby:4.0-slim-trixie
ARG RUBY_IMAGE=ruby@sha256:abd7528c4df35d151e2643d5efb845e442a26e36a4babc6459bee508619137a2

FROM ${RUBY_IMAGE} AS base

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    JEKYLL_ENV=development

# With BUNDLE_PATH set, Bundler nests its downloaded .gem cache one level
# deeper, under a Ruby-ABI-scoped subdirectory (e.g. $BUNDLE_PATH/ruby/4.0.0/cache).
# That path would silently break on every Ruby version bump, so BUNDLE_CACHE_PATH
# pins the cache to a fixed location outside the ABI-scoped tree — this is the
# exact path the "gems" stage below mounts as a BuildKit cache.
ENV BUNDLE_CACHE_PATH=/usr/local/bundle/cache

# Let the apt cache mount actually retain packages.
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
 && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
      > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libyaml-dev \
      pkg-config \
      zlib1g-dev

ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} jekyll \
 && useradd -u ${UID} -g ${GID} -m -s /bin/bash jekyll \
 && mkdir -p /site/_site /site/.jekyll-cache \
 && chown -R jekyll:jekyll /site

WORKDIR /site

# ---------------------------------------------------------------------------
# gems — cached on the lockfile alone, so source edits never re-resolve gems
# ---------------------------------------------------------------------------
FROM base AS gems

COPY Gemfile Gemfile.lock ./
# Mount target matches BUNDLE_CACHE_PATH above, not the ABI-scoped default —
# this is what lets the download cache survive a Ruby version bump.
RUN --mount=type=cache,target=/usr/local/bundle/cache,sharing=locked \
    bundle install && bundle clean --force

# ---------------------------------------------------------------------------
# src — shared source layer for dev and ci
# ---------------------------------------------------------------------------
FROM gems AS src

COPY --chown=jekyll:jekyll . /site
USER jekyll

# ---------------------------------------------------------------------------
# dev — long-running server; source kept current by Compose Watch
# ---------------------------------------------------------------------------
FROM src AS dev

EXPOSE 4000 35729
CMD ["bundle", "exec", "rake", "serve"]

# ---------------------------------------------------------------------------
# ci — self-contained validation and build
# ---------------------------------------------------------------------------
FROM src AS ci

ENV JEKYLL_ENV=production
RUN bundle exec rake ci

# ---------------------------------------------------------------------------
# export — artifact only, nothing else in the layer
# ---------------------------------------------------------------------------
FROM scratch AS export

COPY --from=ci /site/_site /
