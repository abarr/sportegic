defmodule Sportegic.Repo.Migrations.CreateInsurancePolicies do
  use Ecto.Migration

  def change do
    create table(:insurance_policies) do
      add(:number, :string)
      add(:expiry_date, :date)
      add(:issuer, :string)
      add(:additional_info, :string)
      add(:coverage_amount, :money_with_currency)
      add(:type_id, references(:types, on_delete: :nothing))
      add(:person_id, references(:people, on_delete: :delete_all))

      timestamps(type: :timestamptz)
    end

    create(index(:insurance_policies, [:type_id]))
    create(index(:insurance_policies, [:person_id]))
  end
end
