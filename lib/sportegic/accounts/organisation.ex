defmodule Sportegic.Accounts.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Accounts.{User, OrganisationPrefix}

  schema "organisations" do
    field(:display, :string)
    field(:name, :string)
    field(:prefix, OrganisationPrefix)

    many_to_many(:users, User, join_through: "organisations_users")

    timestamps()
  end

  @doc false
  def changeset(organisation, attrs) do
    attrs = Map.put(attrs, "prefix", attrs["display"])

    organisation
    |> cast(attrs, [:name, :display, :prefix])
    |> validate_required([:name, :display, :prefix])
  end
end
