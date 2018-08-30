use Mix.Config

# Configure your database
config :tx_hash, TxHash.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "tx_hash_dev",
  hostname: "localhost",
  pool_size: 10
