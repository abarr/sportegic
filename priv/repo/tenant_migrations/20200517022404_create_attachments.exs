defmodule Sportegic.Repo.Migrations.CreateAttachments do
  use Ecto.Migration

  def change do
    create table(:attachments) do
      add(:file, :string)
      add(:document_id, references(:documents, on_delete: :delete_all))
      add(:visa_id, references(:visas, on_delete: :delete_all))
      add(:insurance_policy_id, references(:insurance_policies, on_delete: :delete_all))

      timestamps(type: :timestamptz)
    end

    create(index(:attachments, [:document_id]))
    create(index(:attachments, [:visa_id]))
    create(index(:attachments, [:insurance_policy_id]))
  end
end
