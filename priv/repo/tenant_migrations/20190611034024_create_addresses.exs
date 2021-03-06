defmodule Sportegic.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add(:unit_number, :string)
      add(:address, :string)
      add(:street_number, :string)
      add(:route, :string)
      add(:locality, :string)
      add(:postal_town, :string)
      add(:sublocality_level_1, :string)
      add(:country, :string)
      add(:administrative_area_level_1, :string)
      add(:administrative_area_level_2, :string)
      add(:postal_code, :string)

      add(:person_id, references(:people, on_delete: :delete_all))
      add(:type_id, references(:types, on_delete: :delete_all))

      timestamps(type: :timestamptz)
    end

    create(index(:addresses, [:person_id]))
  end
end
