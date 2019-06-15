defmodule Sportegic.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add(:name, :string)
      add(:description, :string)

      timestamps(type: :timestamptz)
    end
  end
end
