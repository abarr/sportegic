defmodule Sportegic.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add(:org, :string)
      add(:firstname, :string)
      add(:middle_names, :string)
      add(:lastname, :string)
      add(:dob, :date)
      add(:email, :string)
      add(:mobile, :string)
      add(:preferred_name, :string)
      add(:profile_image, :string)

      timestamps(type: :timestamptz)
    end
  end
end
