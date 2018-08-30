defmodule TxChecker.Notifier do
  alias TxChecker.Explorer.TxDetail

  require Logger

  @behaviour TxChecker.Behaviours.Notifier

  @spec notify(%TxDetail{}) :: none()
  @impl TxChecker.Behaviours.Notifier
  def notify(tx) do
    Logger.debug("*************************************************")
    Logger.debug("Notifying from TxChecker about checking result: #{inspect(tx)}")
    Logger.debug("*************************************************")
  end
end
