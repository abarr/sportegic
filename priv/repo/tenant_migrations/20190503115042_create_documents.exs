defmodule Sportegic.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add(:number, :string)
      add(:expiry_date, :date)
      add(:issuer, :string)
      add(:file, :string)
      add(:additional_info, :string)
      add(:type_id, references(:types, on_delete: :nothing))
      add(:person_id, references(:people, on_delete: :delete_all))

      timestamps()
    end

    create(index(:documents, [:type_id]))
  end
end
