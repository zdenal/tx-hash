defmodule TxHash.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add(:hash, :string)
      add(:chain, :string)
      add(:state, :string)
      add(:error_msg, :string)
      add(:data, :map)

      timestamps()
    end

    create(unique_index(:transactions, [:hash, :chain], name: :unique_hash))
  end
end
