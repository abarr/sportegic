defmodule Sportegic.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :unit_number, :string
      add :address, :string
      add :street_number, :string
      add :route, :string
      add :locality, :string
      add :country, :string
      add :administrative_area_level_1, :string
      add :postal_code, :string
      
      add :person_id, references(:people, on_delete: :delete_all)
      add :type_id, references(:types, on_delete: :delete_all)

      timestamps()
    end

    create index(:addresses, [:person_id])
  end
end
