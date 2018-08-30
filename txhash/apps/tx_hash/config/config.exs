use Mix.Config

config :tx_hash, ecto_repos: [TxHash.Repo]
config :tx_hash, notifier: TxHash.Notifier

config :tx_checker, max_workers: 10_000
config :tx_checker, eth_period: 40_000
config :tx_checker, eth_req_confs: 2
config :tx_checker, eth_max_hits: 4
config :tx_checker, eth_explorer: TxChecker.Explorer.BlockCypher# also Ethplorer is implemented
config :tx_checker, notifier: TxHash.TxProcessor


import_config "#{Mix.env}.exs"
