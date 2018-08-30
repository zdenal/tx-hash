defmodule TxHash.TxProcessor do
  use GenServer

  require Logger

  alias TxHash.Storage
  alias TxHash.Storage.Transaction
  alias TxHash.Config
  alias TxChecker.Explorer.TxDetail
  alias TxHash.Errors.ProcessingError

  @behaviour TxChecker.Behaviours.Notifier

  def start_link() do
    Logger.debug("**********************************")
    Logger.debug("Starting tx checker notifier")
    Logger.debug("**********************************")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl TxChecker.Behaviours.Notifier
  def notify(msg) do
    GenServer.cast(__MODULE__, msg)
  end

  #######################################
  ## Server API
  #######################################
  @impl GenServer
  def init(:ok) do
    {:ok, :ok}
  end

  @impl GenServer
  def handle_cast({:confirmed, hash, %TxDetail{} = tx_detail}, _state) do
    with %Transaction{} = transaction <- Storage.get_transaction_by_hash(hash),
         {:ok, %Transaction{} = transaction} <- Storage.update_transaction(transaction, %{state: "confirmed", data: Map.from_struct(tx_detail)})
    do
      Config.get(:notifier).notify(transaction)
      {:noreply, :ok}
    else
      error -> raise %ProcessingError{message: "Error with postprocessing tx #{hash}. Error: #{error}"}
    end
  end
  def handle_cast({:max_hits, hash, %TxDetail{} = tx_detail}, _state) do
    with %Transaction{} = transaction <- Storage.get_transaction_by_hash(hash),
         {:ok, %Transaction{} = transaction} <- Storage.update_transaction(transaction, %{state: "error", error_msg: "Max hits reached.", data: Map.from_struct(tx_detail)})
    do
      Config.get(:notifier).notify(transaction)
      {:noreply, :ok}
    else
      error -> raise %ProcessingError{message: "Error with postprocessing tx #{hash}. Error: #{error}"}
    end
  end
  def handle_cast({:error, hash, error}, _state) do
    with %Transaction{} = transaction <- Storage.get_transaction_by_hash(hash),
         {:ok, %Transaction{} = transaction} <- Storage.update_transaction(transaction, %{state: "error", error_msg: "#{inspect(error)}"})
    do
      Config.get(:notifier).notify(transaction)
      {:noreply, :ok}
    else
      error -> raise %ProcessingError{message: "Error with postprocessing tx #{hash}. Error: #{error}"}
    end
  end
  def handle_cast(any, _state) do
    raise ArgumentError, message: "No pattern match for process_transaction notifying: " <> inspect(any)
  end
end
