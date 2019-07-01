use Mix.Config

config :sportegic, SportegicWeb.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "localhost", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :sportegic, SportegicWeb.Endpoint, server: true

# config :sportegic, Sportegic.Repo,
#   username: System.fetch_env!("DATABASE_USER"),
#   password: System.fetch_env!("DATABASE_PASS"),
#   database: System.fetch_env!("DATABASE_NAME"),
#   hostname: "127.0.0.1",
#   pool_size: 15

config :sportegic, Sportegic.Repo,
  username: "postgres",
  password: "kiM8s5ngsJbfBEps",
  database: "sportegic-prod",
  hostname: "127.0.0.1",
  pool_size: 15

# Do not print debug messages in production
config :logger, level: :info

config :sportegic, Sportegic.Communication.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: "key-ef2a9b6e6cad2b2beccf0518a6068107",
  domain: "mail.sportegic.com",
  environment: :not_live

config :arc,
  storage: Arc.Storage.GCS,
  bucket: "sportegic-uploads"

config :tesla, adapter: Tesla.Adapter.Hackney  

config :sportegic, Sportegic.Communication.TwilioVerification,
  base_url: "https://verify.twilio.com/v2/Services/VA4cb85cee4a011aaf5c4d29edc2399cfd/",
  twilio_api_key: "ACac7881bb3aa9f0bf4ccf9207cb0525cd",
  twilio_secret_key: "4cd12ff8f4bbc19ab529f67f55d28e9d",
  environment: :not_live

config :goth,
  json: "./rel/deployment/gcp_access/key.json" |> Path.expand() |> File.read!()