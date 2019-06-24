defmodule Sportegic.People.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.People.{ Person }


  schema "profiles" do
    field :available, :boolean, default: true
    belongs_to(:person, Person)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:available])
    |> validate_required([:available])
  end
end
