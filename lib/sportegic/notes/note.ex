defmodule Sportegic.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.LookupTypes.Type

  schema "notes" do
    field(:event_date, :date)
    field(:subject, :string)
    field(:details, :string)
    field(:user_id, :id)

    many_to_many(:types, Type, join_through: "note_type")

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:subject, :details, :event_date])
    |> validate_required([:subject, :details, :event_date])
  end
end
