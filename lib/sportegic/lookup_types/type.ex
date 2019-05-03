defmodule Sportegic.LookupTypes.Type do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.LookupTypes.Lookup

  schema "types" do
    field(:name, :string)
    belongs_to(:lookup, Lookup)

    timestamps()
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name, :lookup_id])
    |> validate_required([:name, :lookup_id])
  end
end
