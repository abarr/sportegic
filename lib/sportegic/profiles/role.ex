defmodule Sportegic.Profiles.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.Profiles.Profile

  schema "roles" do
    field(:name, :string)
    field(:description, :string)
    has_many(:profile, Profile)

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
