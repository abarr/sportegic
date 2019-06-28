defmodule Sportegic.Profiles.PlayingPosition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playing_positions" do
    field :athlete_profile_id, :id
    field :type_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(playing_position, attrs) do
    playing_position
    |> cast(attrs, [:athlete_profile_id])
    |> validate_required([])
  end
end
