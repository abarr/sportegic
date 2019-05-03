defmodule Sportegic.People.Person do
  use Ecto.Schema

  import Ecto.Query, only: [from: 2]
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
      :lastname,
      :email,
      :mobile
    ])
    |> validate_required(:dob, message: "Please provide a Date of Birth")
  end

  def search(people, search_term) do
    wildcard = "%#{search_term}%"

    from(person in people,
      where: ilike(person.firstname, ^wildcard),
      or_where: ilike(person.lastname, ^wildcard),
      or_where: ilike(person.preferred_name, ^wildcard),
      select: %{id: person.id, firstname: person.firstname, lastname: person.lastname}
    )
  end
end
