defmodule Sportegic.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add(:details, :text)
      add(:subject, :string)
      add(:event_date, :utc_datetime)
      add(:user_id, references(:users, on_delete: :nothing))
      add(:sentiment, :float, default: 0.0)

      timestamps(type: :timestamptz)
    end

    create(index(:notes, [:user_id]))
  end
end
