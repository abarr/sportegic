defmodule Sportegic.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Users.User
  alias Sportegic.People.Person
  alias Sportegic.Tasks.TaskPerson

  schema "tasks" do
    field(:action, :string)
    field(:due_date, :date)
    field(:completed, :boolean)

    belongs_to(:user, User)
    belongs_to(:assignee, User, foreign_key: :assignee_id)

    many_to_many(:people, Person, join_through: TaskPerson, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:due_date, :action, :user_id, :assignee_id, :completed])
    |> validate_required([:due_date, :action, :user_id, :assignee_id])
  end
end
