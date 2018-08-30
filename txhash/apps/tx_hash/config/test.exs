use Mix.Config

config :tx_hash, notifier: TxHash.NotifierMock
# Configure your database
config :tx_hash, TxHash.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "tx_hash_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :tx_checker, eth_period: 1
config :tx_checker, eth_max_hits: 3
config :tx_checker, eth_explorer: TxChecker.ExplorerMock
