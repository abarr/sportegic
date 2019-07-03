# ---- Build Stage ----
FROM elixir:1.9.0-alpine AS builder

# Set environment variables for building the application
ENV MIX_ENV=prod \
    LANG=C.UTF-8

RUN apk update \
    && apk --no-cache --update add nodejs nodejs-npm build-base file imagemagick \
    && mix local.rebar --force \
    && mix local.hex --force

# Create the application build directory
RUN mkdir /app
WORKDIR /app

# Copy over all the necessary application files and directories
COPY . .
# Fetch the application dependencies and build the application
RUN mix deps.get --only prod

RUN cd assets \
    && npm install \
    && ./node_modules/webpack/bin/webpack.js --mode production \
    && cd .. \
    && mix phx.digest

RUN mix deps.compile
RUN MIX_ENV=prod mix release

# ---- Application Stage ----
FROM elixir:1.9.0-alpine AS app

ENV LANG=C.UTF-8

# Install openssl
# RUN apt-get update && apt-get install -y openssl
RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*


# Copy over the build artifact from the previous step and create a non root user
WORKDIR /home/app
COPY --from=builder /app/_build .

# Run the Phoenix app
CMD ["./prod/rel/sportegic/bin/sportegic", "start"]