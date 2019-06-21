defmodule Sportegic.Squads.Squad do
  use Ecto.Schema
  import Ecto.Changeset

  schema "squads" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(squad, attrs) do
    squad
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
