defmodule Sportegic.Profiles.AthleteProfile do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Sportegic.People.Person
  alias Sportegic.Profiles.{AthleteProfilePlayingPosition, Performance}
  alias Sportegic.LookupTypes.Type


  schema "athlete_profiles" do
    field :available, :boolean, default: true
    belongs_to(:person, Person)

    has_many(:performances, Performance)
    many_to_many(:positions, Type, join_through: AthleteProfilePlayingPosition, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:available, :person_id])
    |> validate_required([:available, :person_id])
  end

  def update_positions_changeset(%AthleteProfile{} = profile, positions) do
    profile
    |> cast(%{}, [:available, :person_id])
    |> put_assoc(:positions, positions)

  end
end
