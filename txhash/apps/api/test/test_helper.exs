ExUnit.start()

ExUnit.configure(exclude: [:skip])

Ecto.Adapters.SQL.Sandbox.mode(Api.Repo, :manual)
Ecto.Adapters.SQL.Sandbox.mode(TxHash.Repo, {:shared, self()})

Mox.defmock(TxChecker.ExplorerMock, for: TxChecker.Behaviours.Explorer)
