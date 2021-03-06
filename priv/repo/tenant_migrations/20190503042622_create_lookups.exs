defmodule Sportegic.Repo.Migrations.CreateLookups do
  use Ecto.Migration

  def change do
    create table(:lookups) do
      add(:name, :string)
      add(:key, :string)
      add(:description, :string)

      timestamps(type: :timestamptz)
    end
  end
end
