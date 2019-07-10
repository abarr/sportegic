defmodule Sportegic.Repo.Migrations.CreateOrganisations do
  use Ecto.Migration

  def change do
    create table(:organisations) do
      add :name, :string
      add :display, :string
      add :home_city, :string
      add :timezone, :string
      add :prefix, :string

      timestamps(type: :timestamptz)
    end

    create unique_index(:organisations, [:prefix])
    create unique_index(:organisations, [:name])
  end
end
