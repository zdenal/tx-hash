defmodule TxChecker.SupervisorTest do
  use ExUnit.Case

  alias TxChecker.Supervisor
  alias TxChecker.ExplorerMock
  alias TxChecker.Config

  import Mox
  import TxChecker.Support.MockHelper

  setup [:set_mox_global, :verify_on_exit!]

  describe ".confirm_tx/1" do
    test "starting new worker for tx_hash and detecting of existing worker for tx_hash" do
      tx_hash = :erlang.system_time() |> Integer.to_string()
      set_exploler_mock(tx_hash, 1000)

      {:ok, pid} = supervisor_confirm_tx(tx_hash)

      assert {:error, {:already_started, ^pid}} = supervisor_confirm_tx(tx_hash)
    end
  end

  defp supervisor_confirm_tx(hash) do
    Supervisor.confirm_tx(
      hash,
      ExplorerMock,
      %{
        period: Config.eth_period(),
        req_confs: Config.eth_req_confs(),
        max_hits: Config.eth_max_hits()
      }
    )
  end
end
