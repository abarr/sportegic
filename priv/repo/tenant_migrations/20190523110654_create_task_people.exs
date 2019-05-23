defmodule Sportegic.Repo.Migrations.CreateTaskPeople do
  use Ecto.Migration

  def change do
    create table(:task_people) do
      add :task_id, references(:tasks, on_delete: :nothing)
      add :people_id, references(:people, on_delete: :nothing)

      timestamps()
    end

    create index(:task_people, [:task_id])
    create index(:task_people, [:people_id])
  end
end
