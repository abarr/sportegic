defmodule Sportegic.People.Document do
  use Ecto.Schema

  import Ecto.Changeset

  alias Sportegic.People.Person
  alias Sportegic.People.Attachment
  alias Sportegic.LookupTypes.Type

  schema "documents" do
    field(:additional_info, :string)
    field(:expiry_date, :date)
    field(:issuer, :string)
    field(:number, :string)

    belongs_to(:type, Type)
    belongs_to(:person, Person)

    has_many(:attachments, Attachment)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [
      :number,
      :expiry_date,
      :issuer,
      :additional_info,
      :type_id,
      :person_id
    ])
    |> validate_required([ :expiry_date], message: "Please include an expiry date")
    |> validate_required([:number, :issuer, :type_id, :person_id, :expiry_date])
  end
end
