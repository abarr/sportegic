defmodule Sportegic.Users.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Users.Role

  schema "invitations" do
    field :email, :string
    field :org_name, :string
    field :completed, :boolean, default: false
    field :expired, :boolean, default: false
    belongs_to :role, Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:email, :org_name, :role_id, :completed, :expired])
    |> validate_required([:email, :org_name, :role_id])
  end
end
