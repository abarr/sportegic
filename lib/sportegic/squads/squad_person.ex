defmodule Sportegic.Squads.SquadPerson do
  use Ecto.Schema
  import Ecto.Changeset

  schema "squads_people" do
    field :person_id, :id
    field :squad_id, :id

   timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(squad_person, attrs) do
    squad_person
    |> cast(attrs, [:person_id, :squad_id])
    |> validate_required([:person_id, :squad_id])
  end
end
