defmodule Sportegic.Accounts.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Accounts.User

  schema "organisations" do
    field :display, :string
    field :name, :string

    many_to_many(:users, User, join_through: "organisations_users")

    timestamps()
  end

  @doc false
  def changeset(organisation, attrs) do
    organisation
    |> cast(attrs, [:name, :display])
    |> validate_required([:name, :display])
  end
end
