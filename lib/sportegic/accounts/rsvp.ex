defmodule Sportegic.Accounts.Rsvp do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:org, :string)
    field(:email, :string)
    field(:mobile_no, :string)
    field(:country_code, :string)
    field(:password, :string)
    field(:role_id, :string)
  end

  
  def changeset(rsvp, params \\ %{}) do
    rsvp
    |> cast(params,[:firstname, :lastname, :org, :email, :mobile_no, :country_code, :password, :role_id])
  end

end
