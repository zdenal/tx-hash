defmodule TxHash.Storage.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  schema "transactions" do
    field(:hash, :string)
    field(:chain, :string)
    field(:state, :string, default: "processing")
    field(:error_msg, :string)
    field(:data, :map, default: %{})

    timestamps()
  end

  def create_changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, create_cast_attrs())
    |> validate_required(required_attrs())
    |> validate_inclusion(:chain, ["ethereum"])
    |> unique_constraint(:hash, name: :unique_hash)
  end

  def update_changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, update_cast_attrs())
  end

  defp create_cast_attrs,
    do: [:hash, :chain]

  defp update_cast_attrs,
    do: [:state, :error_msg, :data]

  defp required_attrs,
    do: [:hash, :chain]
end
