use Mix.Config

config :sportegic, SportegicWeb.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "localhost", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :sportegic, SportegicWeb.Endpoint, server: true

config :sportegic, Sportegic.Repo,
  username: "postgres",
  database: "sportegic_prod",
  hostname: "127.0.0.1",
  pool_size: 15

config :logger, level: :info

config :sportegic, Sportegic.Communication.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  environment: :live

config :arc,
  storage: Arc.Storage.GCS

config :goth,
  disabled: true


config :tesla, adapter: Tesla.Adapter.Hackney

config :sportegic, Sportegic.Communication.TwilioVerification,
  environment: :live

