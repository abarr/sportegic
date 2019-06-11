defmodule Sportegic.People.Address do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.People.Person
  alias Sportegic.LookupTypes.Type

  schema "addresses" do
    field :address, :string
    field :administrative_area_level_1, :string
    field :country, :string
    field :locality, :string
    field :postal_code, :string
    field :route, :string
    field :street_number, :string
    field :unit_number, :string
    
    belongs_to :person, Person
    belongs_to(:type, Type)

    timestamps()
  end

  @fields [
    :unit_number,
    :address,
    :street_number,
    :route,
    :locality,
    :country,
    :postal_code,
    :person_id,
    :administrative_area_level_1
  ]

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, @fields)
    |> validate_required([:address, :person_id])
  end
end
