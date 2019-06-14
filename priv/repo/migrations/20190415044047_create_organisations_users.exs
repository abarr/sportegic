defmodule Sportegic.Repo.Migrations.CreateOrganisationsUsers do
  use Ecto.Migration

  def change do
    create table(:organisations_users) do
      add :user_id, references(:users, on_delete: :nothing)
      add :organisation_id, references(:organisations, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:organisations_users, [:organisation_id, :user_id])
  end
end
