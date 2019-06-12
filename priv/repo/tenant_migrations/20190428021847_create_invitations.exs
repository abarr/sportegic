defmodule Sportegic.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :email, :string
      add :org_name, :string
      add :completed, :boolean, default: false
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps(type: :timestamptz)
    end

    create index(:invitations, [:role_id])
  end
end
