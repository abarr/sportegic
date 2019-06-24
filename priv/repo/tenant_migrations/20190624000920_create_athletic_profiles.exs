defmodule Sportegic.Repo.Migrations.CreateAthleticProfiles do
  use Ecto.Migration

  def change do
    create table(:athletic_profiles) do
      add(:available, :boolean, default: true, null: false)
      add(:person_id, references(:people, on_delete: :delete_all))

      timestamps(type: :timestamptz)
    end

  end
end
