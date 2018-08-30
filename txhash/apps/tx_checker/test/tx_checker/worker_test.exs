defmodule TxChecker.Ethereum.BlockCypher.WorkerTest do
  use ExUnit.Case

  alias TxChecker.Worker
  alias TxChecker.ExplorerMock
  alias TxChecker.Config

  import Mox
  import TxChecker.Support.MockHelper

  require Logger

  setup [:set_mox_global, :verify_on_exit!]

  describe ".confirm_tx/1" do
    setup do
      %{tx_hash: Integer.to_string(:erlang.system_time())}
    end

    # @tag :skip
    test "Worker behaviour for tx_hash which is confirmed enough", %{tx_hash: tx_hash} do
      set_notifier_mock(:confirmed)
      set_exploler_mock(tx_hash, Config.eth_req_confs())
      {pid, ref} = start_worker(tx_hash)

      # QUESTION
      # Can't catch first msg handling `:check` called from worker init fction.
      # Is good habbit send msg from init with some delay eg. don't use
      # inside init function `send(self(), :check)` but `next_check(opts.period)`??
      #
      # I wanted send msg directly from `init` fction to make first check
      # ASAP and don't block init fction (eg. by checking tx in init fction itself)
      refute_receive {:trace, ^pid, :receive, :check}
      # worker is exited
      assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
    end

    # @tag :skip
    test "Worker behaviour for tx_hash which will have req confs in next round", %{
      tx_hash: tx_hash
    } do
      set_notifier_mock(:confirmed)
      set_exploler_mock(tx_hash, Config.eth_req_confs() - 2)
      set_exploler_mock(tx_hash, Config.eth_req_confs())
      {pid, ref} = start_worker(tx_hash)

      # check method is called second time (1st msg is catchable in test see comment in above test)
      assert_receive {:trace, ^pid, :receive, :check}
      # tx has enough confirmations (set in mock below) none check is called again
      refute_receive {:trace, ^pid, :receive, :check}
      # worker is exited
      assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
    end

    # @tag :skip
    test "reaching max_hits", %{tx_hash: tx_hash} do
      set_notifier_mock(:max_hits)
      set_exploler_mock(tx_hash, Config.eth_req_confs() - 2, Config.eth_max_hits())
      {pid, ref} = start_worker(tx_hash)

      1..(Config.eth_max_hits() - 1)
      |> Enum.each(fn _ -> assert_receive {:trace, ^pid, :receive, :check} end)

      # max hits (tries) was reached ... none check method called again
      refute_receive {:trace, ^pid, :receive, :check}
      # worker is exited
      assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
    end

    # @tag :skip
    test "non existing tx_hash", %{tx_hash: tx_hash} do
      set_notifier_mock(:error)
      set_exploler_mock(tx_hash, 0, 1, {:error, {:api_error, "Transaction  not found."}})

      {pid, ref} = start_worker(tx_hash)

      refute_receive {:trace, ^pid, :receive, :check}
      # worker is exited
      assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
    end
  end

  defp start_worker(hash) do
    opts = %{
      period: Config.eth_period(),
      req_confs: Config.eth_req_confs(),
      max_hits: Config.eth_max_hits()
    }

    {:ok, pid} = Worker.start_link(hash, ExplorerMock, opts)
    :erlang.trace(pid, true, [:receive])
    ref = Process.monitor(pid)

    {pid, ref}
  end
end
