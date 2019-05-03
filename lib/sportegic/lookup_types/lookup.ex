defmodule Sportegic.LookupTypes.Lookup do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.LookupTypes.Type

  schema "lookups" do
    field(:name, :string)
    field(:description, :string)
    has_many(:types, Type)

    timestamps()
  end

  @doc false
  def changeset(lookup, attrs) do
    lookup
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
