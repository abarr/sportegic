defmodule Sportegic.LookupTypes.Type do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.LookupTypes.Lookup
  alias Sportegic.Notes.Note
  # alias Sportegic.People.Document

  schema "types" do
    field(:name, :string)
    belongs_to(:lookup, Lookup)

    # has_many(:document, Document)

    many_to_many(:notes, Note, join_through: "note_type")

    timestamps()
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name, :lookup_id])
    |> validate_required([:name, :lookup_id])
  end
end
