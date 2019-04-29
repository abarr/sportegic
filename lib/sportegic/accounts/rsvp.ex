defmodule Sportegic.Accounts.Rsvp do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:org, :string)
    field(:email, :string)
    field(:mobile, :string)
    field(:password, :string)
    field(:role_id, :string)
  end

  
  def changeset(rsvp, params \\ %{}) do
    rsvp
    |> cast(params,[:firstname, :lastname, :org, :email, :mobile, :password, :role_id])
  end

end
