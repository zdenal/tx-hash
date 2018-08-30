defmodule TxHash.Config do
  def tx_checker do
    if Mix.env == :test do
      get(:tx_checker)
    else
      check_module_config(
        :tx_checker,
        "Please set config variable eg. `config :tx_hash, tx_checker: TxChecker`, got: "
      )
    end
  end

  def get(var) when is_atom(var) do
    Application.get_env(:tx_hash, var)
  end

  @spec check_module_config(atom(), binary()) :: any() | no_return
  defp check_module_config(var, err_message) do
    mod = get(var)

    case Code.ensure_loaded?(mod) do
      true -> mod
      false -> raise ArgumentError, message: err_message <> inspect(mod)
    end
  end
end
