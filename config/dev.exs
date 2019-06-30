use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :sportegic, SportegicWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :sportegic, SportegicWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/sportegic_web/views/.*(ex)$},
      ~r{lib/sportegic_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure your database
config :sportegic, Sportegic.Repo,
  username: "postgres",
  password: "postgres",
  database: "sportegic_dev",
  hostname: "localhost",
  pool_size: 10

config :sportegic, Sportegic.Communication.Mailer, adapter: Swoosh.Adapters.Local

config :arc,
  storage: Arc.Storage.Local

config :goth,
  json: "./rel/deployment/gcp_access/key.json" |> Path.expand() |> File.read!()


