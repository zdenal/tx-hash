use Mix.Config

config :tx_checker, eth_period: 1
config :tx_checker, eth_max_hits: 3
config :tx_checker, eth_explorer: TxChecker.ExplorerMock
config :tx_checker, notifier: TxChecker.NotifierMock
