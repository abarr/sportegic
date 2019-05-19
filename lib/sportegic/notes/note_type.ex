defmodule Sportegic.Notes.NoteType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "note_type" do
    field :note_id, :id
    field :type_id, :id

    timestamps()
  end

  @doc false
  def changeset(note_type, attrs) do
    note_type
    |> cast(attrs, [])
    |> validate_required([])
  end
end
