defmodule TxHash.Support.MockHelper do
  alias TxChecker.Explorer.TxDetail
  alias TxHash.Storage.Transaction
  alias TxHash.NotifierMock

  import Mox

  require Logger

  def set_exploler_mock(hash, confirmations, n \\ 1, resp \\ nil) do
    TxChecker.ExplorerMock
    |> expect(:tx_detail, n, fn ^hash ->
      if resp, do: resp, else: {:ok, %TxDetail{hash: hash, confirmations: confirmations}}
    end)
  end

  def set_notifier_mock(tx_hash, chain) do
    NotifierMock
    |> expect(:notify, fn %Transaction{hash: ^tx_hash, chain: ^chain} = tx -> tx end)
  end
end
