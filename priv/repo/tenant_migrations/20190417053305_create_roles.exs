defmodule Sportegic.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add(:name, :string)
      add(:display, :string)

      timestamps()
    end
  end
end
