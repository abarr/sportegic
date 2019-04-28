defmodule Sportegic.Accounts.Rsvp do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:org, :string)
    field(:email, :string)
    field(:mobile, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:role_id, :string)
  end

  def changeset(rsvp, params \\ %{}) do
    rsvp
    |> cast(params, ~w(firstname lastname org email mobile password role_id))
    |> validate_length(:password,
      min: 6,
      max: 40,
      message: "Password must be at least six characters long"
    )
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
