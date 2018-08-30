defmodule TxHash.Behaviours.Notifier do
  alias TxHash.Storage.Transaction

  @callback notify(%Transaction{}) :: none()
end
