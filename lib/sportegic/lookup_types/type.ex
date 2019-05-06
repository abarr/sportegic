defmodule Sportegic.LookupTypes.Type do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.LookupTypes.Lookup
  alias Sportegic.People.Document

  schema "types" do
    field(:name, :string)
    belongs_to(:lookup, Lookup)

    has_many(:document, Document)

    timestamps()
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name, :lookup_id])
    |> validate_required([:name, :lookup_id])
  end
end
