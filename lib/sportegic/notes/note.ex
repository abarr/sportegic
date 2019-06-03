defmodule Sportegic.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Users.User
  alias Sportegic.People.Person
  alias Sportegic.LookupTypes.Type
  alias Sportegic.Notes.Comment
  alias Sportegic.Notes.NoteType
  alias Sportegic.Notes.NotePerson
  alias Sportegic.Tasks.Task

  @derive {Jason.Encoder, only: [:inserted_at, :subject, :user, :people, :types, :event_date]}

  schema "notes" do
    field(:event_date, :date)
    field(:subject, :string)
    field(:details, :string)

    belongs_to(:user, User)
    has_one(:task, Task, on_delete: :nothing)
    has_many(:comments, Comment, on_delete: :delete_all)

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
