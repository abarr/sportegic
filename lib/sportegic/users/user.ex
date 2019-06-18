defmodule Sportegic.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.Users.Role
  alias Sportegic.Notes.{Note, Comment}

  @derive {Jason.Encoder, only: [:firstname, :lastname]}

  schema "users" do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:mobile, :string)
    field(:mobile_no, :string)
    field(:country_code, :string)
    field(:user_id, :integer)
    field(:disabled, :boolean, default: false)
    belongs_to(:role, Role)

    has_many(:comments, Comment)
    has_many(:notes, Note)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :firstname,
      :lastname,
      :mobile,
      :disabled,
      :user_id,
      :role_id,
      :mobile_no,
      :country_code
    ])
    |> validate_required([:firstname, :lastname, :mobile, :user_id])
  end
end
