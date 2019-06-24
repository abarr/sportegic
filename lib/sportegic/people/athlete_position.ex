defmodule Sportegic.People.AthletePosition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "athlete_positions" do
    field :athletic_profile_id, :id
    field :type_id, :id

    timestamps()
  end

  @doc false
  def changeset(athlete_position, attrs) do
    athlete_position
    |> cast(attrs, [:athletic_profile_id, :type_id])
    |> validate_required([:athletic_profile_id, :type_id])
  end
end
