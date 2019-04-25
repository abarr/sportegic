defmodule Sportegic.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sportegic.Users.Role

  schema "users" do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:mobile, :string)
    field(:user_id, :integer)
    belongs_to(:role, Role)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :mobile, :user_id, :role_id])
    |> validate_required([:firstname, :lastname, :mobile, :user_id])
  end
end
