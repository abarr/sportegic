defmodule Sportegic.Profiles.AthleteProfile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.People.Person
  alias Sportegic.Profiles.PlayingPosition
  alias Sportegic.LookupTypes.Type


  schema "athlete_profiles" do
    field :available, :boolean, default: true
    belongs_to(:person, Person)

    many_to_many(:types, Type, join_through: PlayingPosition, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:available, :person_id])
    |> validate_required([:available, :person_id])
  end
end
