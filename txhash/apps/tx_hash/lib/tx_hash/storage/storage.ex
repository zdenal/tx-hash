defmodule TxHash.Storage do
  @moduledoc """
  The Storage context.
  """

  import Ecto.Query, warn: false
  alias TxHash.Repo
  alias TxHash.Storage.Transaction

  @doc false
  def list_transactions() do
    Repo.all(Transaction)
  end

  @doc false
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  def update_transaction(%Transaction{} = transaction, attrs) do
    # TODO: here cound be some make some state logic principle as
    # update only transaction with specific state or so on ....
    transaction
    |> Transaction.update_changeset(attrs)
    |> Repo.update()
  end

  @doc false
  def get_transaction_by_hash(hash) do
    case Repo.get_by(Transaction, hash: hash) do
      %Transaction{} = tx -> tx
      nil -> {:error, :not_found}
    end
  end

  @doc false
  def get_transaction(id) do
    Transaction |> Repo.get(id)
  end
end
