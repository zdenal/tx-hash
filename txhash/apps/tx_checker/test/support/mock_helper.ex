defmodule TxChecker.Support.MockHelper do
  alias TxChecker.Explorer.TxDetail
  alias TxChecker.{NotifierMock, ExplorerMock}

  import Mox

  def set_exploler_mock(hash, confirmations, n \\ 1, resp \\ nil) do
    ExplorerMock
    |> expect(:tx_detail, n, fn ^hash ->
      if resp, do: resp, else: {:ok, %TxDetail{hash: hash, confirmations: confirmations}}
    end)
  end

  def set_notifier_mock(type) do
    NotifierMock
    |> expect(:notify, fn {^type, _hash, _tx} -> :ok end)
  end
end
