defmodule Sportegic.People.Attachment do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Sportegic.People.{Document, Visa}

  schema "attachments" do
    field(:file, Sportegic.People.File.Type)
    belongs_to(:document, Document)
    belongs_to(:visa, Visa)

    timestamps()
  end

  @doc false
  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:document_id])
    |> cast_attachments(attrs, [:file])
    |> validate_required([:file])
  end
end
