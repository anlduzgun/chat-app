# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :messaging_app_api,
  ecto_repos: [MessagingAppApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :messaging_app_api, MessagingAppApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: MessagingAppApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: MessagingAppApi.PubSub,
  live_view: [signing_salt: "2T8Bj9z/"]
#Configures the Guardian
config :messaging_app_api, MessagingAppApiWeb.Auth.Guardian,
  issuer: "messaging_app_api",
  secret_key: "UJ/pKxEs9HTMrF0l6zgtc5zKpv/6IDkKjAToZF1xAz4IY2irneklbkGXWZQ+jTqb"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
