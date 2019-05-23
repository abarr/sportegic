defmodule Sportegic.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :details, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :note_id, references(:notes, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:note_id])
  end
end
