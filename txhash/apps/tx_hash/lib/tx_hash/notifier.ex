defmodule TxHash.Notifier do
  alias TxHash.Storage.Transaction

  require Logger

  @behaviour TxHash.Behaviours.Notifier

  @spec notify(%Transaction{}) :: none()
  @impl TxHash.Behaviours.Notifier
  def notify(tx) do
    Logger.debug("*************************************************")
    Logger.debug("Notifying from TxHash about updating transaction: #{inspect(tx)}")
    Logger.debug("*************************************************")
  end
end
