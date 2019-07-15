defmodule Sportegic.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types) do
      add(:name, :string)
      add(:key, :string)
      add(:lookup_id, references(:lookups, on_delete: :delete_all))

      timestamps(type: :timestamptz)
    end

    create(index(:types, [:name]))
    create(unique_index(:types, [:key]))
  end
end
