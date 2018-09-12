defmodule ApiWeb.TransactionChannel do
  use ApiWeb, :channel
  alias ApiWeb.TransactionView, as: View

  alias TxHash.Storage
  alias TxHash.Storage.Transaction
  alias ApiWeb.ChangesetView

  require Logger

  def join("transaction:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("list", _payload, socket) do
    json = View.render("index.json", %{transactions: Storage.list_transactions()})

    {:reply, {:ok, json}, socket}
  end

  def handle_in("create", tx_params, socket) do
    with {:ok, %Transaction{} = transaction} <- TxHash.process_transaction(tx_params["hash"], tx_params["chain"]) do
      json = View.render("show.json", %{transaction: transaction})

      broadcast(socket, "new_transaction", json)
      {:reply, :ok, socket}
    else
      {:error, error} -> handle_create_error_response(error, socket)
    end
  end

  defp handle_create_error_response(%Ecto.Changeset{} = changeset, socket) do
    err_res = ChangesetView.render("error.json", %{changeset: changeset})

    {:reply, {:error, err_res}, socket}
  end
  defp handle_create_error_response(:unsupported_chain, socket) do
    {:reply, {:error, %{errors: %{chain: :unsupported_chain}}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

