defmodule Sportegic.Notes.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.Notes.Note
  alias Sportegic.Users.User

  schema "comments" do
    field :details, :string

    belongs_to :user, User
    belongs_to :note, Note

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:details, :user_id, :note_id])
    |> validate_required([:details, :user_id, :note_id])
  end
end
