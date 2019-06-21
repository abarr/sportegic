defmodule Sportegic.Repo.Migrations.CreateSquads do
  use Ecto.Migration

  def change do
    create table(:squads) do
      add :name, :string
      add :description, :text

      timestamps(type: :timestamptz)
    end

  end
end
