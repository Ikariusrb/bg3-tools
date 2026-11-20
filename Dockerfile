# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. It follows janus-admin-core's
# Dockerfile, minus the PostgreSQL client (this app uses SQLite).

# Make sure RUBY_VERSION matches .ruby-version
ARG RUBY_VERSION=3.4.13
# Multi-arch index digest, so --platform still resolves. Recompute with:
#   docker buildx imagetools inspect docker.io/library/ruby:<version>-slim | awk '/^Digest:/{sub(/^sha256:/,"",$2); print $2}'
ARG RUBY_SHA256=03e203fab47d495a1d0046d10040db89367b361328ecd4af469f0433e2dd9ce1
FROM docker.io/library/ruby:$RUBY_VERSION-slim@sha256:$RUBY_SHA256 AS base

# Optional cache busting for security updates
ARG CACHE_DATE

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
#
# BOOTSNAP_CACHE_DIR moves the compile cache off /rails/tmp, so the `chown -R` in the final stage
# doesn't copy it into a second layer just to change its owner. It stays root-owned for the same
# reason /rails is: cache entries are compiled ISeq that get loaded and executed, so a writable
# cache would let a compromised process plant code that runs on the next load. BOOTSNAP_READONLY
# is set in the final stage rather than here — see the note there.
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test ops" \
    BOOTSNAP_CACHE_DIR="/bootsnap"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Re-declare in this stage so they're in scope here (an ARG from a prior stage
# isn't inherited): RUBY_VERSION for the bundle cache-mount id below, CACHE_DATE
# so the weekly bust also re-runs THIS stage's apt layer (build deps).
ARG RUBY_VERSION
ARG CACHE_DATE

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev libcrypt-dev node-gyp pkg-config python-is-python3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install JavaScript dependencies
ARG NODE_VERSION=24.19.0
# Recompute with:
#   curl -fsSL https://nodejs.org/dist/v<version>/SHASUMS256.txt | awk '/linux-x64\.tar\.gz$/{print $1}'
ARG NODE_SHA256=f625d97cd707df4ff96254916fbc5ff014f09c09effe5a1e0ca8f6d41a8789d4
ENV PATH=/usr/local/node/bin:$PATH

# Install Node.js from the official tarball, pinned to version and checksum.
ADD --checksum=sha256:$NODE_SHA256 \
    https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz /tmp/node.tar.gz
RUN tar xzf /tmp/node.tar.gz -C /usr/local && \
    mv /usr/local/node-v${NODE_VERSION}-linux-x64 /usr/local/node

# Install application gems
COPY Gemfile Gemfile.lock ./
# Parallel install/compile jobs (bundle install reads BUNDLE_JOBS). Override with
# --build-arg BUNDLE_JOBS=N.
ARG BUNDLE_JOBS=2
ENV BUNDLE_JOBS=${BUNDLE_JOBS}
# Incremental gem builds: install into a persistent BuildKit cache mount
# (/bundle-cache) instead of straight into BUNDLE_PATH, so compiled native
# extensions survive across builds. The token is for the private janus-ops source
# in the Gemfile; the ops group itself is excluded by BUNDLE_WITHOUT.
RUN --mount=type=secret,id=github_token \
    --mount=type=cache,id=bundle-${RUBY_VERSION},target=/bundle-cache,sharing=locked \
    BUNDLE_RUBYGEMS__PKG__GITHUB__COM="Bearer:$(cat /run/secrets/github_token)" \
    BUNDLE_PATH=/bundle-cache bundle install && \
    mkdir -p "${BUNDLE_PATH}" && \
    cp -a /bundle-cache/. "${BUNDLE_PATH}/" && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules. esbuild is a regular dependency, not a devDependency, because
# assets:precompile bundles the JavaScript with it.
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && \
    rm -rf node_modules/.cache

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile && \
    rm -rf node_modules

# Final stage for app image
FROM base

# Copy built artifacts: gems, application, bootsnap cache
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails
COPY --from=build "${BOOTSNAP_CACHE_DIR}" "${BOOTSNAP_CACHE_DIR}"

# Runtime-only: the build stage must be free to WRITE this cache, so the flag belongs here and
# not in `base`.
ENV BOOTSNAP_READONLY="1"

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
