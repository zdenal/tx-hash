defmodule TxChecker.Worker do
  use GenServer, restart: :temporary
  alias TxChecker.Config
  require Logger

  alias TxChecker.Explorer.TxDetail

  # Using this style with assign it on compile time
  # causes random tests error when swithcing between apps
  # and executing tests.
  # @notifier Config.get(:notifier)

  @spec start_link(binary(), module(), map()) :: GenServer.on_start()
  def start_link(tx_hash, explorer, opts) when is_binary(tx_hash) do
    GenServer.start_link(__MODULE__, {tx_hash, explorer, opts}, name: name_for(tx_hash, explorer))
  end

  @spec name_for(binary(), module()) :: {:global, {:tx_check, binary(), module()}}
  def name_for(tx_hash, explorer), do: {:global, {:tx_check, tx_hash, explorer}}

  #################################################
  ## Server API
  #################################################
  def init({tx_hash, explorer, opts}) do
    Logger.debug("#{inspect(self())}: #{inspect(explorer)} check worker started for #{tx_hash}.")

    send(self(), :check)

    {:ok, %{hits: 0, tx_hash: tx_hash, confirmed: false, explorer: explorer, opts: opts}}
  end

  def handle_info(:check, %{tx_hash: tx_hash, confirmed: false, explorer: explorer} = state) do
    explorer.tx_detail(tx_hash)
    |> handle_response(state)
  end

  defp handle_response(
         {:ok, %TxDetail{confirmations: confirmations} = tx},
         %{tx_hash: hash, hits: hits, opts: %{req_confs: req_confs}} = state
       )
       when confirmations >= req_confs do
    Logger.debug(
      "#{inspect(self())}: Terminating process... Transatcion #{hash} confirmed by #{
        confirmations
      } blocks."
    )

    # @notifier.notify({:confirmed, hash, tx})
    Config.get(:notifier).notify({:confirmed, hash, tx})

    {:stop, :normal, %{state | confirmed: true, hits: hits + 1}}
  end

  defp handle_response({:ok, %TxDetail{} = tx}, %{
         tx_hash: hash,
         hits: hits,
         opts: %{max_hits: max_hits}
       })
       when hits >= max_hits - 1 do
    Logger.debug("#{inspect(self())}: Terminating process... reaching max hits #{max_hits}.")

    # @notifier.notify({:max_hits, hash, tx})
    Config.get(:notifier).notify({:max_hits, hash, tx})

    {:stop, :normal, {:error, :max_hits}}
  end

  defp handle_response({:ok, _resp}, %{hits: hits, opts: %{period: period}} = state) do
    Logger.debug("Not enough hits.")
    next_check(period)

    {:noreply, %{state | hits: hits + 1}}
  end

  defp handle_response({:error, error}, %{tx_hash: hash}) do
    Logger.debug("#{inspect(self())}: Terminating process... Error #{inspect(error)}.")

    # @notifier.notify({:error, hash, error})
    Config.get(:notifier).notify({:error, hash, error})

    {:stop, :normal, error}
  end

  defp next_check(period) do
    Process.send_after(self(), :check, period)
  end
end
