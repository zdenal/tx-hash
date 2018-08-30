defmodule TxChecker do
  alias TxChecker.Config

  @moduledoc """
  TxChecker is library for checking transactions in specifiyc blockchains.


  Example of conf vars:

    config :tx_checker, max_workers: 10_000
    config :tx_checker, eth_period: 6_000
    config :tx_checker, eth_req_confs: 2
    config :tx_checker, eth_max_hits: 20
  """

  @doc """
  Run worker which will repeatedly get detail of set transaction and check if transaction
  confirmation meet required confirmations (set by env)

  ## Examples

      iex> TxChecker.confirm_tx("0xb911b6bc7290bbd119dd8a68ab595655803c543f3680e2ede5a06ecbc3789204", :ethereum)
      {:ok, #PID<0.268.0>}

      iex> TxChecker.confirm_tx("0xb911b6bc7290bbd119dd8a68ab595655803c543f3680e2ede5a06ecbc3789204", :ethereum)
      {:error, {:already_started, #PID<0.268.0>}}

      iex> TxChecker.confirm_tx("0xb911b6bc7290bbd119dd8a68ab595655803c543f3680e2ede5a06ecbc3789204", :unsupported_chain)
      {:error, :unsupported_chain}

  """

  @type confirm_result :: DynamicSupervisor.on_start_child() | {:error, :unsupported_chain}

  @spec confirm_tx(binary(), atom()) :: confirm_result
  def confirm_tx(tx_hash, chain)

  def confirm_tx(tx_hash, :ethereum) do
    explorer = Config.eth_explorer()

    TxChecker.Supervisor.confirm_tx(
      tx_hash,
      explorer,
      %{
        period: Config.eth_period(),
        req_confs: Config.eth_req_confs(),
        max_hits: Config.eth_max_hits()
      }
    )
  end

  def confirm_tx(_tx_hash, _chain) do
    {:error, :unsupported_chain}
  end
end
