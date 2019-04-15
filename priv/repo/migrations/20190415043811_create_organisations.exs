defmodule Sportegic.Repo.Migrations.CreateOrganisations do
  use Ecto.Migration

  def change do
    create table(:organisations) do
      add :name, :string
      add :display, :string

      timestamps()
    end

  end
end
