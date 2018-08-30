defmodule TxHash do
  @moduledoc """
  """

  alias TxHash.{Storage}
  alias TxHash.Storage.Transaction
  alias Ecto.Changeset

  @type result ::
    {:ok, %Transaction{}}
    | {:error, %Changeset{}}
    | {:error, :unsupported_chain}

  @doc """
  Start process of checking transaction
  ## Examples

      iex> TxHash.process_transaction("0xb911b6bc7290bbd119dd8a68ab595655803c543f3680e2ede5a06ecbc3789204", "ethereum")
  """
  @spec process_transaction(binary(), binary()) :: result
  def process_transaction(tx_hash, chain) do
    with {:ok, %Transaction{id: tx_id} = transaction} <- Storage.create_transaction(%{hash: tx_hash, chain: chain}),
         {:ok, _pid} <- TxChecker.confirm_tx(tx_hash, String.to_atom(chain))
    do
      {:ok, transaction}
    else
      {:error, error} -> handle_error(error)
    end
  end

  defp handle_error(%Changeset{} = changeset) do
    {:error, changeset}
  end
  defp handle_error(:unsupported_chain) do
    {:error, :unsupported_chain}
  end
end
