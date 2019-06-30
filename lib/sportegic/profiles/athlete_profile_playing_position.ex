defmodule Sportegic.Profiles.AthleteProfilePlayingPosition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "athlete_profile_playing_position" do
    field :athlete_profile_id, :id
    field :type_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile_position, attrs) do
    profile_position
    |> cast(attrs, [:athlete_profile_id, :type_id])
    |> validate_required([:athlete_profile_id, :type_id])
  end
end
