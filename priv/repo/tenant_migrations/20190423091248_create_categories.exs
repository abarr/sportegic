defmodule Sportegic.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:name, :string)
      add(:key, :string)

      timestamps(type: :timestamptz)
    end
  end
end
