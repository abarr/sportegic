# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sportegic,
  ecto_repos: [Sportegic.Repo]

# Configures the endpoint
config :sportegic, SportegicWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+WKpBrPTxg9B+AmdhRIeJYaCE5A/ITKmgxi2blVBviv0Dh89Y5SW6BU7C1fhMF0B",
  render_errors: [view: SportegicWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sportegic.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :triplex, repo: Sportegic.Repo

config :sportegic, Sportegic.Communication.TwilioVerification,
  base_url: "https://verify.twilio.com/v2/Services/VA4cb85cee4a011aaf5c4d29edc2399cfd/",
  twilio_api_key: "ACac7881bb3aa9f0bf4ccf9207cb0525cd",
  twilio_secret_key: "4cd12ff8f4bbc19ab529f67f55d28e9d"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
