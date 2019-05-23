defmodule Sportegic.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :due_date, :date
      add :action, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :assignee_id, references(:users, on_delete: :nothing)
      

      timestamps()
    end

    create index(:tasks, [:user_id])
    create index(:tasks, [:assignee_id])
  end
end
