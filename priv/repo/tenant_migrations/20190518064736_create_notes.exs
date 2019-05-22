defmodule Sportegic.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add(:details, :text)
      add(:subject, :string)
      add(:event_date, :date)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:notes, [:user_id]))
  end
end
