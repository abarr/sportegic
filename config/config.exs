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


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
