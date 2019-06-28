defmodule Sportegic.Repo.Migrations.CreateProfilesPosition do
  use Ecto.Migration

  def change do
    create table(:playing_positions) do
      add :athlete_profile_id, references(:athlete_profiles, on_delete: :nothing)
      add :type_id, references(:types, on_delete: :nothing)

      timestamps()
    end

    create index(:playing_positions, [:athlete_profile_id])
    create index(:playing_positions, [:type_id])
  end
end
