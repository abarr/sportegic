defmodule Sportegic.Repo.Migrations.CreateProfilesPosition do
  use Ecto.Migration

  def change do
    create table(:profiles_position) do
      add :profile_id, references(:profiles, on_delete: :nothing)
      add :type_id, references(:types, on_delete: :nothing)

      timestamps()
    end

    create index(:profiles_position, [:profile_id])
    create index(:profiles_position, [:type_id])
  end
end
