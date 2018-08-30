defmodule TxHash.StorageTest do
  use TxHash.DataCase

  alias TxHash.Storage.Transaction

  @subject TxHash.Storage

  describe ".create_transaction/1" do
    test "transaction is good to process" do
      assert {:ok, %Transaction{}} = @subject.create_transaction(%{hash: "hash", chain: "ethereum"})
    end

    test "transaction is already exists in DB" do
      @subject.create_transaction(%{hash: "hash", chain: "ethereum"})

      assert {:error, changeset} = @subject.create_transaction(%{hash: "hash", chain: "ethereum"})
      assert "has already been taken" in errors_on(changeset).hash
    end
  end

  describe ".update_transaction/2" do
    setup [:create_tx]

    test "valid update", %{transaction: transaction} do
      assert {:ok, %Transaction{}} = @subject.update_transaction(transaction, %{state: "confirmed", data: %{hash: "hash"}})
    end

    test "can't update hash or chain", %{transaction: transaction} do
      assert {:ok, %Transaction{hash: origin_hash, chain: origin_chain}} = @subject.update_transaction(transaction, %{hash: "new_hash", chain: "new_chain", state: "confirmed", data: %{hash: "hash"}})
    end
  end

  defp create_tx(_context) do
    {:ok, tx} =
      @subject.create_transaction(%{
        hash: "test",
        chain: "ethereum",
      })

    {:ok, transaction: tx}
  end
end
