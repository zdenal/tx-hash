defmodule TxChecker.Config do
  def max_workers do
    check_gt_integer_config(
      :max_workers,
      "Please set config variable eg. `config :tx_checker, :max_workers, 10_000, got: "
    )
  end

  def eth_period do
    check_gt_integer_config(
      :eth_period,
      "Please set config variable eg. `config :tx_checker, eth_period: 60_000`, got: "
    )
  end

  def eth_req_confs do
    check_gt_integer_config(
      :eth_req_confs,
      "Please set config variable eg. `config :tx_checker, eth_req_confs: 2`, got: "
    )
  end

  def eth_max_hits do
    check_gt_integer_config(
      :eth_max_hits,
      "Please set config variable eg. `config :tx_checker, eth_max_hits: 20`, got: "
    )
  end

  def eth_explorer do
    check_module_config(
      :eth_explorer,
      "Please set config variable eg. `config :tx_checker, eth_explorer: TxChecker.Explorer.BlockCypher`, got: "
    )
  end

  def get(var) when is_atom(var) do
    Application.get_env(:tx_checker, var)
  end

  @spec check_gt_integer_config(atom(), binary()) :: integer() | no_return
  defp check_gt_integer_config(var, err_message) do
    case get(var) do
      n when is_integer(n) and n > 0 -> n
      els -> raise ArgumentError, message: err_message <> inspect(els)
    end
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
