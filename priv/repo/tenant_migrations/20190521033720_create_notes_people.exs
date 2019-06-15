defmodule Sportegic.Repo.Migrations.CreateNotesPeople do
  use Ecto.Migration

  def change do
    create table(:notes_people) do
      add(:person_id, references(:people, on_delete: :nothing))
      add(:note_id, references(:notes, on_delete: :nothing))

      timestamps(type: :timestamptz)
    end

    create(index(:notes_people, [:person_id]))
    create(index(:notes_people, [:note_id]))
  end
end
