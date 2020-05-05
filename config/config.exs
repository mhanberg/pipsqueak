# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pipsqueak,
  ecto_repos: [Pipsqueak.Repo]

config :phoenix, :template_engines,
  exs: Temple.Engine,
  lexs: Temple.LiveViewEngine,
  leex: Phoenix.LiveView.Engine

# Configures the endpoint
config :pipsqueak, PipsqueakWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BnyiUm7Wbsg4vH2sAo8F/LwtR9owEbWC3R7+dnsNu5fyjNhuLazqM6H+5MMwf8Ls",
  render_errors: [view: PipsqueakWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pipsqueak.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "iLZbVIC0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
