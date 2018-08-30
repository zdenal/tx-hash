defmodule ApiWeb.TransactionView do
  use ApiWeb, :view
  alias ApiWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      chain: transaction.chain,
      hash: transaction.hash,
      state: transaction.state,
      error_msg: transaction.error_msg
    }
  end
end
