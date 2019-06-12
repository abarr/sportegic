defmodule Sportegic.People.InsurancePolicy do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.LookupTypes.Type
  alias Sportegic.People.Person
  alias Sportegic.People.Attachment

  schema "insurance_policies" do
    field(:additional_info, :string)
    field(:coverage_amount, Money.Ecto.Composite.Type)
    field(:expiry_date, :date)
    field(:issuer, :string)
    field(:number, :string)

    belongs_to(:type, Type)
    belongs_to(:person, Person)

    has_many(:attachments, Attachment)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(insurance_policy, attrs) do
    insurance_policy
    |> cast(attrs, [
      :number,
      :expiry_date,
      :issuer,
      :additional_info,
      :coverage_amount,
      :type_id,
      :person_id
    ])
    |> validate_required([:number, :expiry_date, :issuer, :type_id, :person_id])
  end
end
