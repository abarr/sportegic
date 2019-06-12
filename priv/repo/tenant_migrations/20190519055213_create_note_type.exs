defmodule Sportegic.Repo.Migrations.CreateNoteType do
  use Ecto.Migration

  def change do
    create table(:note_type) do
      add :note_id, references(:notes, on_delete: :nothing)
      add :type_id, references(:types, on_delete: :nothing)

      timestamps(type: :timestamptz)
    end

    create index(:note_type, [:note_id])
    create index(:note_type, [:type_id])
  end
end
