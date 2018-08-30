defmodule TxChecker.Behaviours.Notifier do
  alias TxChecker.Explorer.TxDetail

  @callback notify(%TxDetail{}) :: none()
end
