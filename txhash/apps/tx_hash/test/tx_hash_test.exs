defmodule TxHashTest do
  use TxHash.DataCase

  import Mox
  import TxHash.Support.MockHelper

  alias TxHash.Storage.Transaction
  alias TxHash.Storage
  alias TxHash.TxProcessor
  alias TxChecker.Config, as: CheckerConfig

  require Logger

  setup [:set_mox_global, :verify_on_exit!]

  describe ".process_transaction/2" do
    setup do
      processor_pid = Process.whereis(TxProcessor)
      :erlang.trace(processor_pid, true, [:receive])
      :sys.trace(processor_pid, true)

      req_confs = CheckerConfig.eth_req_confs()

      %{tx_hash: Integer.to_string(:erlang.system_time), req_confs: req_confs, processor_pid: processor_pid}
    end

    #@tag :skip
    test "new transaction which is confirmed", %{tx_hash: tx_hash, req_confs: req_confs, processor_pid: pid} do
      set_notifier_mock(tx_hash, "ethereum")
      set_exploler_mock(tx_hash, req_confs)

      TxHash.process_transaction(tx_hash, "ethereum")
      assert_receive {:trace, ^pid, :receive, {:"$gen_cast", {:confirmed, _, _}}}
      refute_receive {:trace, ^pid, :receive, {:"$gen_cast", _}}

      assert %Transaction{hash: ^tx_hash, chain: "ethereum", state: "confirmed"} = Storage.get_transaction_by_hash(tx_hash)
    end

    #@tag :skip
    test "already processed transaction", %{tx_hash: tx_hash} do
      chain = "ethereum"

      Storage.create_transaction(%{hash: tx_hash, chain: chain})
      assert {:error, %Ecto.Changeset{errors: [hash: _]}} = TxHash.process_transaction(tx_hash, chain)
    end

    #@tag :skip
    test "not existed transaction", %{tx_hash: tx_hash, processor_pid: pid} do
      error = {:api_error, "Transaction  not found."}
      error_msg = "#{inspect(error)}"
      set_exploler_mock(tx_hash, 0, 1, {:error, error})
      set_notifier_mock(tx_hash, "ethereum")

      TxHash.process_transaction(tx_hash, "ethereum")
      assert_receive {:trace, ^pid, :receive, {:"$gen_cast", {:error, _, _}}}
      refute_receive {:trace, ^pid, :receive, {:"$gen_cast", _}}

      assert %Transaction{hash: ^tx_hash, chain: "ethereum", state: "error", error_msg: ^error_msg } = Storage.get_transaction_by_hash(tx_hash)
    end

    #@tag :skip
    test "when max_hits is reached for process transaction", %{tx_hash: tx_hash, processor_pid: pid} do
      set_exploler_mock(tx_hash, CheckerConfig.eth_req_confs() - 2, CheckerConfig.eth_max_hits())
      set_notifier_mock(tx_hash, "ethereum")

      TxHash.process_transaction(tx_hash, "ethereum")
      assert_receive {:trace, ^pid, :receive, {:"$gen_cast", {:max_hits, _, _}}}
      refute_receive {:trace, ^pid, :receive, {:"$gen_cast", _}}

      assert %Transaction{hash: ^tx_hash, chain: "ethereum", state: "error", error_msg: "Max hits reached." } = Storage.get_transaction_by_hash(tx_hash)
    end
  end
end
