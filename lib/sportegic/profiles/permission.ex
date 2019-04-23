defmodule Sportegic.Profiles.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Profiles.Category

  schema "permissions" do
    field(:name, :string)
    belongs_to(:category, Category)

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name, :category_id])
    |> validate_required([:name, :category_id])
  end
end
