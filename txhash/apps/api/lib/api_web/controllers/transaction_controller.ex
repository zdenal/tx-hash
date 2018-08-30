defmodule ApiWeb.TransactionController do
  use ApiWeb, :controller

  alias TxHash.Storage
  alias TxHash.Storage.Transaction

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    transactions = Storage.list_transactions()
    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, %{"transaction" => params}) do
    with {:ok, %Transaction{} = transaction} <- TxHash.process_transaction(params["hash"], params["chain"]) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    case Storage.get_transaction(id) do
      %Transaction{} = transaction -> render(conn, "show.json", transaction: transaction)
      nil -> {:error, :not_found}
    end
  end
end
