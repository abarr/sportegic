defmodule Sportegic.LookupTypes.Lookup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lookups" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(lookup, attrs) do
    lookup
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
