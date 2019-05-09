defmodule Sportegic.People.Attachment do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Sportegic.People.Document

  schema "attachments" do
    field(:file, Sportegic.People.File.Type)
    belongs_to(:document, Document)

    timestamps()
  end

  @doc false
  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:document_id, :file])
    |> cast_attachments(attrs, [:file])
    |> validate_required([:file, :document_id])
  end
end
