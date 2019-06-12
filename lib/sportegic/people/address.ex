defmodule Sportegic.People.Address do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.People.Person
  alias Sportegic.LookupTypes.Type

  schema "addresses" do
    field(:address, :string)
    field(:administrative_area_level_1, :string)
    field(:administrative_area_level_2, :string)
    field(:country, :string)
    field(:locality, :string)
    field(:postal_town, :string)
    field(:sublocality_level_1, :string)
    field(:postal_code, :string)
    field(:route, :string)
    field(:street_number, :string)
    field(:unit_number, :string)

    belongs_to(:person, Person)
    belongs_to(:type, Type)

    timestamps(type: :utc_datetime)
  end

  @fields [
    :type_id,
    :unit_number,
    :address,
    :street_number,
    :route,
    :locality,
    :postal_town,
    :sublocality_level_1,
    :country,
    :postal_code,
    :person_id,
    :administrative_area_level_1,
    :administrative_area_level_2,
  ]

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, @fields)
    |> validate_required([:address, :person_id])
  end
end
