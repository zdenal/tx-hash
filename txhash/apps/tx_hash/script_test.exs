# execute with: iex -S mix run script_test.exs
require Logger

TxHash.process_transaction("0xb911b6bc7290bbd119dd8a68ab595655803c543f3680e2ede5a06ecbc3789204", "ethereum")
|> inspect
|> Logger.debug
