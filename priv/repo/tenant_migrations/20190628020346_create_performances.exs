defmodule Sportegic.Repo.Migrations.CreatePerformances do
  use Ecto.Migration

  def change do
    create table(:performances) do
      add :review, :text
      add :performance_date, :utc_datetime
      add :athlete_profile_id, references(:athlete_profiles, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :performance_area_id, references(:types, on_delete: :nothing)
      add :context_id, references(:types, on_delete: :nothing)
      add :rating_id, references(:types, on_delete: :nothing)


      timestamps(type: :timestamptz)
    end

    create index(:performances, [:performance_area_id])
    create index(:performances, [:user_id])
    create index(:performances, [:context_id])
  end
end
