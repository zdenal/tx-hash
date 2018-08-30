defmodule Api.TransactionChannelTest do
  use ApiWeb.ChannelCase

  alias ApiWeb.TransactionChannel
  alias TxHash.Storage
  alias ApiWeb.TransactionView, as: View
  alias TxChecker.Config, as: CheckerConfig

  alias TxHash.Support.MockHelper

  import Mox

  setup [:set_mox_global, :verify_on_exit!]

  @create_attrs %{hash: "tx_hash", chain: "ethereum"}
  @invalid_attrs %{hash: "tx_hash"}

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(TransactionChannel, "transaction:lobby")

    req_confs = CheckerConfig.eth_req_confs()

    {:ok, socket: socket, req_confs: req_confs}
  end

  #@tag :skip
  test "list replies with status list of transactions", %{socket: socket} do
    {:ok, transaction} = Storage.create_transaction(@create_attrs)
    res = render_transactions([transaction])

    ref = push(socket, "list")
    assert_reply(ref, :ok, ^res)
  end

  describe "creating tx" do
    #@tag :skip
    test "new_transaction broadcasts, after tx is processed broadcast again", %{socket: socket, req_confs: req_confs} do
      hash = @create_attrs.hash
      MockHelper.set_exploler_mock(hash, req_confs)

      push(socket, "create", @create_attrs)

      assert_broadcast("new_transaction", new_res)
      assert_broadcast("processed_tx", processed_res)

      assert %{data: %{hash: ^hash, state: "processing"}} = new_res

      id = new_res.data.id
      assert %{id: ^id, hash: ^hash, state: "confirmed"} = processed_res.data
    end

    #@tag :skip
    test "reply error to socket when invalid", %{socket: socket} do
      ref = push(socket, "create", @invalid_attrs)

      assert_reply(ref, :error, %{errors: %{chain: _}})
    end

    #@tag :skip
    test "reply error to socket when transaction exists", %{socket: socket} do
      {:ok, _transaction} = Storage.create_transaction(@create_attrs)

      ref = push(socket, "create", @create_attrs)

      assert_reply(ref, :error, %{errors: %{hash: _}})
    end
  end

  defp render_transactions(transactions) do
    View.render("index.json", %{transactions: transactions})
  end
end
