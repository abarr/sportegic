defmodule Sportegic.Profiles.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Profiles.Category
  alias Sportegic.Profiles.Role
  alias Sportegic.Profiles.RolesPermissions

  schema "permissions" do
    field(:name, :string)
    belongs_to(:category, Category)

    many_to_many(:roles, Role,
      join_through: RolesPermissions,
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name, :category_id])
    |> validate_required([:name, :category_id])
  end
end
