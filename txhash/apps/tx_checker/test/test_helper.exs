ExUnit.start()

ExUnit.configure(exclude: [:skip, :net])

Mox.defmock(TxChecker.ExplorerMock, for: TxChecker.Behaviours.Explorer)
Mox.defmock(TxChecker.NotifierMock, for: TxChecker.Behaviours.Notifier)
