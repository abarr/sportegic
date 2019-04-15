defmodule Sportegic.Accounts.OrganisationsUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organisations_users" do
    field :user_id, :id
    field :organisation_id, :id

    timestamps()
  end

  @doc false
  def changeset(organisations_users, attrs) do
    organisations_users
    |> cast(attrs, [:user_id, :organisation_id])
    |> validate_required([:user_id, :organisation_id])

  end
end
