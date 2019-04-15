defmodule Sportegic.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sportegic.Accounts.Organisation

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field(:password, :string, virtual: true)

    many_to_many(:organisations, Organisation, join_through: "organisations_users")

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_length(:password, [min: 6, max: 40, message: "Password must be at least six characters long"])
    |> validate()
    |> put_pass_hash()
  end

  def validate(user) do
    user
    |> validate_required([:email, :password])
    |> unique_constraint(:email,
      name: "users_email_index",
      message: "This Email has already been registered"
    )
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{ password: password }} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

end
