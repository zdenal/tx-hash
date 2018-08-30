defmodule TxChecker.Explorer.BlockCypherTest do
  use ExUnit.Case, async: true
  alias TxChecker.Explorer.BlockCypher

  describe "BlockCypher.tx_detail/1" do
    @tag :net
    test "returns detail of transaction" do
      tx_hash = "b911b6bc7290bbd119dd8a68ab595655803c543f3680e2ede5a06ecbc3789204"

      {:ok, %{"hash" => ^tx_hash, "block_index" => 138}} = BlockCypher.tx_detail(tx_hash)
    end

    @tag :net
    test "returns error about non existing tx" do
      tx_hash = "non_exisiting_tx_hash"

      {:error, {:api_error, "Transaction  not found."}} = BlockCypher.tx_detail(tx_hash)
    end
  end
end
