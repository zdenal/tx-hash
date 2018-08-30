# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  namespace: Api,
  ecto_repos: [Api.Repo]

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bhspW6gDOJJeHprRotL+W76XhPmLdUlPRi+MqAxzZQfDDgt2wnVgSga8LHyYBXx2",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Api.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]


config :tx_hash, ecto_repos: [TxHash.Repo]
config :tx_hash, tx_checker: TxChecker
config :tx_hash, notifier: Api.TransactionNotifier

config :tx_checker, max_workers: 10_000
config :tx_checker, eth_period: 40_000
config :tx_checker, eth_req_confs: 2
config :tx_checker, eth_max_hits: 4
config :tx_checker, eth_explorer: TxChecker.Explorer.BlockCypher# also Ethplorer is implemented
config :tx_checker, notifier: TxHash.TxProcessor


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
