defmodule Sportegic.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:due_date, :timestamptz)
      add(:action, :text)
      add(:completed, :boolean, default: false)
      add(:completed_date, :timestamptz)
      add(:user_id, references(:users, on_delete: :nothing))
      add(:assignee_id, references(:users, on_delete: :nothing))
      add(:completed_by_id, references(:users, on_delete: :nothing))
      add(:note_id, references(:notes, on_delete: :delete_all), null: true)

      timestamps(type: :timestamptz)
    end

    create(index(:tasks, [:user_id]))
    create(index(:tasks, [:assignee_id]))
  end
end
