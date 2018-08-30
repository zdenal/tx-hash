defmodule TxHash.Application do
  @moduledoc """
  The TxHash Application Service.

  The tx_hash system business domain lives in this application.

  Exposes API to clients such as the `TxHashWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Logger.debug("#{inspect(self())} Starting the tx_hash app ...")

    Supervisor.start_link([
      supervisor(TxHash.Repo, []),
      worker(TxHash.TxProcessor, [])
    ], strategy: :one_for_one, name: TxHash.Supervisor)
  end
end
