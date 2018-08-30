defmodule TxChecker.Behaviours.Explorer do
  @type tx_hash :: binary()
  @type response :: map()
  @type reason :: atom()

  @callback tx_detail(tx_hash) ::
              {:ok, response}
              | {:error, reason}
end
