defmodule Sportegic.Profiles.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.Profiles.Profile
  alias Sportegic.Profiles.Permission
  alias Sportegic.Profiles.RolesPermissions

  schema "roles" do
    field(:name, :string)
    field(:description, :string)
    has_many(:profile, Profile)

    many_to_many(:permissions, Permission,
      join_through: RolesPermissions,
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
