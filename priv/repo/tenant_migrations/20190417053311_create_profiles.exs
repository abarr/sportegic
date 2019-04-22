defmodule Sportegic.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add(:firstname, :string)
      add(:lastname, :string)
      add(:mobile, :string)
      add(:user_id, :integer)
      add(:role_id, references(:roles, on_delete: :nothing))

      timestamps()
    end
  end
end
