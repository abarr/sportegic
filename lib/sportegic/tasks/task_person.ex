defmodule Sportegic.Tasks.TaskPerson do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_person" do
    field(:task_id, :id)
    field(:person_id, :id)

    timestamps()
  end

  @doc false
  def changeset(task_person, attrs) do
    task_person
    |> cast(attrs, [:task_id, :person_id])
    |> validate_required([:task_id, :person_id])
  end
end
