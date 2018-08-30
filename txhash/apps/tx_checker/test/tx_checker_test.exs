defmodule TxCheckerTest do
  use ExUnit.Case

  import Mox
  import TxChecker.Support.MockHelper

  setup [:set_mox_global, :verify_on_exit!]

  describe "TxChecker.confirm_tx/1" do
    setup do
      %{tx_hash: Integer.to_string(:erlang.system_time())}
    end

    # @tag :skip
    test "try confirm tx_hash which is already in checking process for ethereum chain", %{
      tx_hash: tx_hash
    } do
      set_exploler_mock(tx_hash, 1000)

      {:ok, pid} = TxChecker.confirm_tx(tx_hash, :ethereum)

      assert {:error, {:already_started, pid}} == TxChecker.confirm_tx(tx_hash, :ethereum)
    end

    # @tag :skip
    test "unsopported chain" do
      assert {:error, :unsupported_chain} == TxChecker.confirm_tx("txhash", :non_supported)
    end
  end
end
