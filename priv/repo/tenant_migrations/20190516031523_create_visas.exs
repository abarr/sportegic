defmodule Sportegic.Repo.Migrations.CreateVisas do
  use Ecto.Migration

  def change do
    create table(:visas) do
      add :expiry_date, :date
      add :issued_date, :date
      add :issuer, :string
      add :allowed_stay, :string
      add :additional_info, :string
      add :number, :string
      add :type_id, references(:types, on_delete: :nothing)
      add :person_id, references(:people, on_delete: :nothing)

      timestamps()
    end

    create index(:visas, [:type_id])
    create index(:visas, [:person_id])
  end
end
