defmodule Sportegic.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:firstname, :string)
      add(:lastname, :string)
      add(:fullname, :string)
      add(:mobile, :string)
      add(:mobile_no, :string)
      add(:country_code, :string)
      add(:disabled, :boolean, default: false)
      add(:user_id, :integer)
      add(:role_id, references(:roles, on_delete: :nothing))

      timestamps(type: :timestamptz)
    end
  end
end
