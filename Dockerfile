# ---- Stage 1: Build ----
FROM bitwalker/alpine-elixir:latest6 AS build


ENV MIX_ENV=prod \
  LANG=C.UTF-8

WORKDIR /app

# Install dependencies and tools
RUN apk add --no-cache \
  build-base \
  git \
  curl \
  nodejs \
  npm \
  postgresql-client \
  python3

# Install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy mix files and fetch deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy app and assets
COPY lib lib
COPY priv priv
COPY assets assets

# Build static assets
RUN mix assets.deploy

# Compile project and build release
RUN mix compile
RUN mix release

# ---- Stage 2: Release Runtime ----
FROM alpine:3.21 AS app

RUN apk add --no-cache \
  libstdc++ \
  openssl \
  ncurses-libs

WORKDIR /app

# Copy release from build
COPY --from=build /app/_build/prod/rel/stock_dashboard ./

# Required ENV vars for runtime
ENV MIX_ENV=prod \
  PHX_SERVER=true \
  PORT=4000

EXPOSE 4000

# Run the release
CMD ["bin/stock_dashboard", "start"]
