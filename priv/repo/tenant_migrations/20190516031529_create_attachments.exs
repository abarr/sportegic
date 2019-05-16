defmodule Sportegic.Repo.Migrations.CreateAttachments do
  use Ecto.Migration

  def change do
    create table(:attachments) do
      add(:file, :string)
      add(:document_id, references(:documents, on_delete: :delete_all))
      add(:visa_id, references(:visas, on_delete: :delete_all))

      timestamps()
    end

    create(index(:attachments, [:document_id]))
  end
end
