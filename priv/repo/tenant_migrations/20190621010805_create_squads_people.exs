defmodule Sportegic.Repo.Migrations.CreateSquadsPeople do
  use Ecto.Migration

  def change do
    create table(:squads_people) do
      add :person_id, references(:people, on_delete: :nothing)
      add :squad_id, references(:squads, on_delete: :delete_all)

      timestamps(type: :timestamptz)
    end

    create index(:squads_people, [:person_id])
    create index(:squads_people, [:squad_id])
  end
end
