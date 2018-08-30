defmodule ApiWeb.TransactionControllerTest do
  use ApiWeb.ConnCase

  alias TxHash.Storage
  alias TxHash.Storage.Transaction
  alias TxHash.Support.MockHelper
  alias TxChecker.Config, as: CheckerConfig

  import Mox

  setup [:set_mox_global, :verify_on_exit!]

  @create_attrs %{hash: "tx_hash", chain: "ethereum"}
  @invalid_attrs %{hash: "tx_hash"}

  setup %{conn: conn} do
    req_confs = CheckerConfig.eth_req_confs()

    {:ok, conn: put_req_header(conn, "accept", "application/json"), req_confs: req_confs}
  end

  describe "index" do
    #@tag :skip
    test "lists all transactions", %{conn: conn} do
      {:ok, %Transaction{hash: hash, chain: chain}} = Storage.create_transaction(@create_attrs)

      conn = get(conn, transaction_path(conn, :index))
      assert [%{"chain" => ^chain, "hash" => ^hash}] = json_response(conn, 200)["data"]
    end
  end

  describe "show" do
    #@tag :skip
    test "detail of transaction", %{conn: conn} do
      {:ok, %Transaction{id: id, chain: chain}} = Storage.create_transaction(@create_attrs)

      conn = get(conn, transaction_path(conn, :show, id))
      assert %{"chain" => ^chain, "id" => ^id} = json_response(conn, 200)["data"]
    end

    #@tag :skip
    test "detail of non-existing transaction", %{conn: conn} do
      conn = get(conn, transaction_path(conn, :show, 9999))
      assert json_response(conn, 404)
    end
  end

  describe "create transaction" do
    #@tag :skip
    test "renders transaction when data is valid", %{conn: conn, req_confs: req_confs} do
      MockHelper.set_exploler_mock(@create_attrs.hash, req_confs)

      conn = post(conn, transaction_path(conn, :create), transaction: @create_attrs)
      assert %{"id" => id, "hash" => hash} = json_response(conn, 201)["data"]

      conn = get(conn, transaction_path(conn, :show, id))
      assert %{"id" => ^id, "hash" => ^hash} = json_response(conn, 200)["data"]
    end

    #@tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, transaction_path(conn, :create), transaction: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    #@tag :skip
    test "renders errors when tx already exists", %{conn: conn} do
      {:ok, %Transaction{}} = Storage.create_transaction(@create_attrs)

      conn = post conn, transaction_path(conn, :create), transaction: @create_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when chain is not supported", %{conn: conn} do
      conn = post conn, transaction_path(conn, :create), transaction: %{hash: "hash", chain: "unsupported-chain"}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
