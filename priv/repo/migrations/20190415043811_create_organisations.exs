defmodule Sportegic.Repo.Migrations.CreateOrganisations do
  use Ecto.Migration

  def change do
    create table(:organisations) do
      add :name, :string
      add :display, :string
      add :prefix, :string

      timestamps(type: :timestamptz)
    end
  end
end
