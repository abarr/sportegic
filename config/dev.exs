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

config :sportegic, Sportegic.Communication.Mailer, 
  adapter: Swoosh.Adapters.Local,
  environment: :live

config :arc,
  storage: Arc.Storage.Local

config :goth,
  json: "./rel/deployment/gcp_access/key.json" |> Path.expand() |> File.read!()

config :tesla, adapter: Tesla.Adapter.Hackney  

config :sportegic, Sportegic.Communication.TwilioVerification,
  base_url: "https://verify.twilio.com/v2/Services/VA4cb85cee4a011aaf5c4d29edc2399cfd/",
  twilio_api_key: "ACac7881bb3aa9f0bf4ccf9207cb0525cd",
  twilio_secret_key: "4cd12ff8f4bbc19ab529f67f55d28e9d",
  environment: :live
