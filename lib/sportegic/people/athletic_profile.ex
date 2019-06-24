defmodule Sportegic.People.AthleticProfile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.People.{ Person }


  schema "athletic_profiles" do
    field :available, :boolean, default: true
    belongs_to(:person, Person)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(athletic_profile, attrs) do
    athletic_profile
    |> cast(attrs, [:available])
    |> validate_required([:available])
  end
end
