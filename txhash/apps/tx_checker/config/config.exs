# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# in miliseconds
config :tx_checker, max_workers: 10_000
config :tx_checker, eth_period: 40_000
config :tx_checker, eth_req_confs: 2
config :tx_checker, eth_max_hits: 4
config :tx_checker, eth_explorer: TxChecker.Explorer.BlockCypher
config :tx_checker, notifier: TxChecker.Notifier

import_config "#{Mix.env()}.exs"
