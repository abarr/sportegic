defmodule Sportegic.Profiles.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.Profiles.Profile

  schema "roles" do
    field(:name, :string)
    field(:display, :string)
    has_many(:profile, Profile)

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :display])
    |> validate_required([:name, :display])
  end
end
