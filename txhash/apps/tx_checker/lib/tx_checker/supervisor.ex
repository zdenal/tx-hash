defmodule TxChecker.Supervisor do
  use DynamicSupervisor
  require Logger

  alias TxChecker.Config
  alias TxChecker.Worker

  @max_workers Config.max_workers()

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec confirm_tx(binary(), module(), map()) :: DynamicSupervisor.on_start_child()
  def confirm_tx(tx_hash, explorer, opts) when is_binary(tx_hash) do
    case find_confirmator(tx_hash, explorer) do
      nil -> start_worker(tx_hash, explorer, opts)
      pid -> {:error, {:already_started, pid}}
    end
  end

  #################################################
  ## Server API
  #################################################
  @impl DynamicSupervisor
  def init(_) do
    Logger.debug("#{inspect(self())} Starting the ConfirmatorSupervisor module...")
    DynamicSupervisor.init(strategy: :one_for_one, max_children: @max_workers)
  end

  defp start_worker(tx_hash, explorer, opts) when is_binary(tx_hash),
    do: DynamicSupervisor.start_child(__MODULE__, worker_spec(tx_hash, explorer, opts))

  defp find_confirmator(tx_hash, explorer) when is_binary(tx_hash) do
    GenServer.whereis(Worker.name_for(tx_hash, explorer))
  end

  defp worker_spec(tx_hash, explorer, opts) do
    Supervisor.child_spec(
      Worker,
      start: {Worker, :start_link, [tx_hash, explorer, opts]},
      restart: :transient
    )
  end
end
