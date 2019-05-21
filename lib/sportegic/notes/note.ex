defmodule Sportegic.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Users.User
  alias Sportegic.People.Person
  alias Sportegic.LookupTypes.Type
  alias Sportegic.Notes.NoteType
  alias Sportegic.Notes.NotePerson

  schema "notes" do
    field(:event_date, :date)
    field(:subject, :string)
    field(:details, :string)
    belongs_to(:user, User)

    many_to_many(:types, Type, join_through: NoteType, on_replace: :delete)
    many_to_many(:people, Person, join_through: NotePerson, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:subject, :details, :event_date, :user_id])
    |> validate_required([:subject, :details, :event_date])
  end
end
