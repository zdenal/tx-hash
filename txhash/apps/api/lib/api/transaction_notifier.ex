defmodule Api.TransactionNotifier do
  use GenServer

  require Logger

  alias TxHash.Storage.Transaction
  alias ApiWeb.TransactionView, as: View

  @behaviour TxHash.Behaviours.Notifier

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl TxHash.Behaviours.Notifier
  def notify(msg) do
    GenServer.cast(__MODULE__, {:notify, msg})
  end

  #######################################
  ## Server API
  #######################################
  @impl GenServer
  def init(:ok) do
    {:ok, :ok}
  end

  @impl GenServer
  def handle_cast({:notify, %Transaction{} = tx}, _state) do
    json = View.render("show.json", %{transaction: tx})

    ApiWeb.Endpoint.broadcast("transaction:lobby", "processed_tx", json)
    {:noreply, :ok}
  end
end
