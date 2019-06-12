defmodule Sportegic.Users.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.Users.User
  alias Sportegic.Users.Invitation
  alias Sportegic.Users.Permission
  alias Sportegic.Users.RolesPermissions

  schema "roles" do
    field(:name, :string)
    field(:description, :string)
    has_many(:users, User)
    has_many(:invitations, Invitation)

    many_to_many(:permissions, Permission,
      join_through: RolesPermissions,
      on_replace: :delete
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
