defmodule Sportegic.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field(:dob, :date)
    field(:email, :string)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:middle_names, :string)
    field(:mobile, :string)
    field(:preferred_name, :string)

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:firstname, :middle_names, :lastname, :dob, :email, :mobile, :preferred_name])
    |> validate_required([
      :firstname,
      :middle_names,
      :lastname,
      :email,
      :mobile,
      :preferred_name
    ])
    |> validate_required(:dob, message: "Please provide a Date of Birth")
  end
end
