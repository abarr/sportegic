defmodule Sportegic.People.Document do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Sportegic.People
  alias Sportegic.People.Person
  alias Sportegic.LookupTypes.Type

  schema "documents" do
    field(:additional_info, :string)
    field(:expiry_date, :date)
    field(:file, Sportegic.People.PersonDocument.Type)
    field(:issuer, :string)
    field(:number, :string)
    belongs_to(:type, Type)
    belongs_to(:person, Person)

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:number, :expiry_date, :issuer, :additional_info, :type_id, :person_id])
    |> cast_attachments(attrs, [:file])
    |> validate_required([:number, :issuer, :type_id, :person_id])
  end
end
