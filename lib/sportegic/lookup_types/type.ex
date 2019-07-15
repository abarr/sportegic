defmodule Sportegic.LookupTypes.Type do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.LookupTypes.Lookup
  alias Sportegic.Notes.Note
  alias Sportegic.Notes.NoteType
  
  @derive {Jason.Encoder, only: [:name]}

  schema "types" do
    field(:name, :string)
    field(:key, :string)
    belongs_to(:lookup, Lookup)

    many_to_many(:notes, Note, join_through: NoteType)
    
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name, :lookup_id, :key])
    |> validate_required([:name, :lookup_id])
  end
end
