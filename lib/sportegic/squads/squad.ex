defmodule Sportegic.Squads.Squad do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.People.{Person}
  alias Sportegic.Squads.SquadPerson

  schema "squads" do
    field :name, :string
    field :description, :string

    many_to_many(:people, Person, join_through: SquadPerson, on_replace: :delete)
    
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(squad, attrs) do
    squad
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
