defmodule Sportegic.People.Person do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Sportegic.People.{Document, Visa, InsurancePolicy}
  alias Sportegic.Notes.Note
  alias Sportegic.Notes.NotePerson
  alias Sportegic.Tasks.Task
  alias Sportegic.Tasks.TaskPerson

  schema "people" do
    field(:dob, :date)
    field(:email, :string)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:middle_names, :string)
    field(:mobile, :string)
    field(:preferred_name, :string)
    field(:profile_image, Sportegic.People.Avatar.Type)

    has_many(:document, Document)
    has_many(:insurance_policy, InsurancePolicy)
    has_many(:visa, Visa)

    many_to_many(:notes, Note, join_through: NotePerson)
    many_to_many(:tasks, Task, join_through: TaskPerson)

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:firstname, :middle_names, :lastname, :dob, :email, :mobile, :preferred_name])
    |> cast_attachments(attrs, [:profile_image])
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
      select: %{id: person.id, firstname: person.firstname, lastname: person.lastname, dob: person.dob}
    )
  end
end
