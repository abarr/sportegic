defmodule Sportegic.Repo.Migrations.CreateAthletePositions do
  use Ecto.Migration

  def change do
    create table(:athlete_positions) do
      add :athletic_profile_id, references(:athletic_profiles, on_delete: :nothing)
      add :type_id, references(:types, on_delete: :nothing)

      timestamps()
    end

    create index(:athlete_positions, [:athletic_profile_id])
    create index(:athlete_positions, [:type_id])
  end
end
