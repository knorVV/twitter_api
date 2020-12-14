# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :twitter_api,
  ecto_repos: [TwitterApi.Repo]

# Configures the endpoint
config :twitter_api, TwitterApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hYiMT4TavHkzydtHJBBMjonuGxdlqMpoD/e/cnu7fbacMfk0OKXM79d6DDgIVPMP",
  render_errors: [view: TwitterApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TwitterApi.PubSub,
  live_view: [signing_salt: "HaH8nKB+"]

# guardian
config :twitter_api, TwitterApiWeb.Auth.Guardian,
  issuer: "twitter_api",
  secret_key: "E+pKsEo46A5qq5qdE9QojHEZd0iDK5bn1fzbpOXGcb42XO3tuTGqpVaz/VUirpPD"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
