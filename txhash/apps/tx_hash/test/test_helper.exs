ExUnit.start()

ExUnit.configure(exclude: [:skip])

Ecto.Adapters.SQL.Sandbox.mode(TxHash.Repo, :manual)

Mox.defmock(TxChecker.ExplorerMock, for: TxChecker.Behaviours.Explorer)
Mox.defmock(TxHash.NotifierMock, for: TxHash.Behaviours.Notifier)
