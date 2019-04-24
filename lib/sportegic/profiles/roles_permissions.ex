defmodule Sportegic.Profiles.RolesPermissions do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Profiles.Role
  alias Sportegic.Profiles.Permission

  schema "roles_permissions" do
    belongs_to(:role, Role)
    belongs_to(:permission, Permission)

    timestamps()
  end

  @doc false
  def changeset(roles_permissions, attrs) do
    roles_permissions
    |> cast(attrs, [:role_id, :permission_id])
    |> validate_required([:role_id, :permission_id])
  end
end
