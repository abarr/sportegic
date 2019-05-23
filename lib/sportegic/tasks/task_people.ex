defmodule Sportegic.Tasks.TaskPeople do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_people" do
    field(:task_id, :id)
    field(:people_id, :id)

    timestamps()
  end

  @doc false
  def changeset(task_people, attrs) do
    task_people
    |> cast(attrs, [:task_id, :people_id])
    |> validate_required([:task_id, :people_id])
  end
end
