defmodule Sportegic.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add(:name, :string)
      add(:category_id, references(:categories, on_delete: :nothing))

      timestamps()
    end

    create(index(:permissions, [:category_id]))
  end
end
