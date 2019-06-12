defmodule Sportegic.Accounts.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Accounts.{User, OrganisationPrefix}

  schema "organisations" do
    field(:display, :string)
    field(:name, :string)
    field(:home_city, :string)
    field(:prefix, OrganisationPrefix)

    many_to_many(:users, User, join_through: "organisations_users")

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organisation, attrs) do
    attrs = Map.put(attrs, "prefix", attrs["display"])

    organisation
    |> cast(attrs, [:name, :display, :prefix, :home_city])
    |> validate_required([:name, :display, :prefix])
  end
end
