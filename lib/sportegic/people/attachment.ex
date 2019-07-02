defmodule Sportegic.People.Attachment do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Sportegic.People.{Document, Visa, InsurancePolicy}

  schema "attachments" do
    field(:file, Sportegic.People.File.Type)
    field(:org, :string)
    field(:uuid, :string)

    belongs_to(:document, Document)
    belongs_to(:insurance_policy, InsurancePolicy)
    belongs_to(:visa, Visa)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attachment, attrs) do
    attrs = Map.put(attrs, :uuid, Ecto.UUID.generate())
    attachment
    |> cast(attrs, [:document_id, :visa_id, :insurance_policy_id, :org, :uuid])
    |> cast_attachments(attrs, [:file])
    |> validate_required([:file, :org, :uuid])
  end
end
