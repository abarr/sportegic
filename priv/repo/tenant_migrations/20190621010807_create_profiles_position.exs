defmodule Sportegic.Repo.Migrations.CreateProfilesPosition do
  use Ecto.Migration

  def change do
    create table(:athlete_profile_playing_position) do
      add :athlete_profile_id, references(:athlete_profiles, on_delete: :nothing)
      add :type_id, references(:types, on_delete: :nothing)

      timestamps()
    end

    create index(:athlete_profile_playing_position, [:athlete_profile_id])
    create index(:athlete_profile_playing_position, [:type_id])
    create(unique_index(:athlete_profile_playing_position, [:athlete_profile_id, :type_id]))
  end
end
