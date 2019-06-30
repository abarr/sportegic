defmodule Sportegic.Profiles.Performance do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.Profiles.AthleteProfile
  alias Sportegic.Users.User
  alias Sportegic.LookupTypes.Type


  schema "performances" do
    field :review, :string
    field(:performance_date, :utc_datetime)
    belongs_to(:athlete_profile, AthleteProfile)
    belongs_to(:user, User)
    belongs_to(:performance_area, Type, foreign_key: :performance_area_id)
    belongs_to(:context, Type, foreign_key: :context_id)
    belongs_to(:rating, Type, foreign_key: :rating_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(performance, attrs) do
    performance
    |> cast(attrs, [:review, :performance_area_id, :context_id, :athlete_profile_id, :user_id, :rating_id, :performance_date])
    |> validate_required([:review, :performance_area_id, :context_id, :athlete_profile_id, :user_id, :rating_id, :performance_date])
  end
end
