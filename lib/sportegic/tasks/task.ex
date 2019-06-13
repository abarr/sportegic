defmodule Sportegic.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Users.User
  alias Sportegic.People.Person
  alias Sportegic.Tasks.TaskPerson
  alias Sportegic.Notes.Note

  schema "tasks" do
    field(:action, :string)
    field(:due_date, :utc_datetime)
    field(:completed, :boolean)
    field(:completed_date, :utc_datetime)

    belongs_to(:note, Note)
    belongs_to(:user, User)
    belongs_to(:assignee, User, foreign_key: :assignee_id)
    belongs_to(:completed_by, User, foreign_key: :completed_by_id)

    many_to_many(:people, Person, join_through: TaskPerson, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:due_date, :action, :user_id, :assignee_id, :completed, :note_id, :completed_date, :completed_by_id])
    |> validate_required([:due_date, :action, :user_id, :assignee_id])
  end
end
