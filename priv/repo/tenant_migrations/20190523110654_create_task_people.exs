defmodule Sportegic.Repo.Migrations.CreateTaskPerson do
  use Ecto.Migration

  def change do
    create table(:task_person) do
      add(:task_id, references(:tasks, on_delete: :nothing))
      add(:person_id, references(:people, on_delete: :nothing))

      timestamps(type: :timestamptz)
    end

    create(index(:task_person, [:task_id]))
    create(index(:task_person, [:person_id]))
  end
end
