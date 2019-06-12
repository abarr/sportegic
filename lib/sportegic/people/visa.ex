defmodule Sportegic.People.Visa do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.LookupTypes.Type
  alias Sportegic.People.Person
  alias Sportegic.People.Attachment

  schema "visas" do
    field :additional_info, :string
    field :expiry_date, :date
    field :issued_date, :date
    field :issuer, :string
    field :allowed_stay, :string
    field :number, :string
    
    belongs_to :type, Type
    belongs_to :person, Person

    has_many(:attachments, Attachment)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(visa, attrs) do
    visa
    |> cast(attrs, [:expiry_date, :issued_date, :issuer, :additional_info, :number, :type_id, :person_id, :allowed_stay])
    |> validate_required([:expiry_date, :issued_date, :issuer, :additional_info, :number, :type_id, :person_id])
  end
end
