defmodule Sportegic.Repo.Migrations.CreateLookups do
  use Ecto.Migration

  def change do
    create table(:lookups) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
