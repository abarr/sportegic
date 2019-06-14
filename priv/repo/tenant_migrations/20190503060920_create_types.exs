defmodule Sportegic.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types) do
      add(:name, :string)
      add(:lookup_id, references(:lookups, on_delete: :delete_all))

      timestamps()
    end

    create(index(:types, [:lookup_id]))
  end
end
