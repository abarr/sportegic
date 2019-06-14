defmodule Sportegic.Repo.Migrations.CreateRolesPermissions do
  use Ecto.Migration

  def change do
    create table(:roles_permissions) do
      add(:role_id, references(:roles, on_delete: :nothing))
      add(:permission_id, references(:permissions, on_delete: :nothing))

      timestamps()
    end

    create(unique_index(:roles_permissions, [:role_id, :permission_id]))
  end
end
