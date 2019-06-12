defmodule Sportegic.Notes.NotePerson do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes_people" do
    field :person_id, :id
    field :note_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(note_person, attrs) do
    note_person
    |> cast(attrs, [:person_id, :note_id])
    |> validate_required([:person_id, :note_id])
  end
end
