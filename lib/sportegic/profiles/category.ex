defmodule Sportegic.Profiles.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Profiles.Permission

  schema "categories" do
    field(:name, :string)
    field(:key, :string)
    has_many(:permission, Permission)

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :key])
    |> validate_required([:name, :key])
  end
end
