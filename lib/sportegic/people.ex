defmodule Sportegic.People do
  @moduledoc """
  The People context.
  """
  import Ecto.Query, warn: false
  use Timex
  alias Ecto.Multi
  alias Sportegic.Repo
  alias Sportegic.People.{Person, Document, Attachment, Visa, InsurancePolicy, Address}
  alias Sportegic.Notes.Note
  alias Sportegic.Profiles


  defdelegate authorize(action, user, params), to: Sportegic.Users.Authorisation

  @doc """
  Returns the list of people.

  ## Examples

      iex> list_people(org)
      [%Person{}, ...]

  """
  def list_people(search, org) do
    Person
    |> Person.search(search)
    |> Repo.all(prefix: org)
  end

  def list_people(org) do
    Repo.all(Person, prefix: org)
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123, org)
      %Person{}

      iex> get_person!(456, org)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id, org) do
    query =
      from(n in Note,
        order_by: [asc: n.inserted_at],
        preload: [:user, :types, :people],
        limit: 3
      )

    Person
    |> Repo.get!(id, prefix: org)
    |> Repo.preload([:document, :visa, :insurance_policy, :addresses,[ athlete_profile: [:types]], [notes: query]])
  end

  def get_person_athlete_profile!(id, org) do
    Person
    |> Repo.get!(id, prefix: org)
    |> Repo.preload([athlete_profile: [:types, :performances]])
  end

  def get_person_only(id, org) do
    Person
    |> Repo.get!(id, prefix: org)
  end

  # name will include DOB in format "FIRSTNAME LASTNAME (MNTH, DAY, YEAR)"
  def get_person_by_name_dob(name, org) when is_binary(name) do
    [firstname, lastname | _] = String.split(name, " ")
    [_, dob] = String.splitter(name, ["(", ")"]) |> Enum.take(2)

    dob =
      dob
      |> Timex.parse!("{Mfull} {D}, {YYYY}")
      |> Timex.to_date()

    Person
    |> Repo.get_by([firstname: firstname, lastname: lastname, dob: dob], prefix: org)
  end

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}, org) do
    {:ok, person} = %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert(prefix: org)

    case Profiles.create_athlete_profile(person, org) do
      {:ok, _profile} -> {:ok, person}
      error -> error
    end

  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs, org) do
    person
    |> Person.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a Person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person, org) do
    Repo.delete(person, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{source: %Person{}}

  """
  def change_person(%Person{} = person) do
    Person.changeset(person, %{})
  end

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents(person, org) do
    Document
    |> where([d], d.person_id == ^person.id)
    |> Repo.all(prefix: org)
    |> Repo.preload(type: [:lookup], attachments: [])
  end

  @doc """
  Gets a single document.

  Raises `Ecto.NoResultsError` if the Document does not exist.

  ## Examples

      iex> get_document!(123)
      %Document{}

      iex> get_document!(456)
      ** (Ecto.NoResultsError)

  """
  def get_document!(person, id, org) do
    Document
    |> where([d], d.person_id == ^person.id)
    |> Repo.get!(id, prefix: org)
    |> Repo.preload([:attachments, :type])
  end

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_document(attrs \\ %{}, org) do
    case attrs["attachments"] do
      nil ->
        create_document_without_attachments(attrs, org)

      _ ->
        create_document_with_attachments(attrs, org)
    end
  end

  def create_document_without_attachments(attrs, org) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_document_with_attachments(attrs, org) do
    multi = Multi.new()

    multi
    |> Multi.run(:document, fn _repo, _changes ->
      create_document_without_attachments(attrs, org)
    end)
    |> Multi.run(:attachments, fn _repo, %{document: %{id: document_id}} ->
      list =
        attrs["attachments"]
        |> Enum.map(fn f -> %{file: f, document_id: document_id} end)
        |> Enum.map(&create_attachment(&1, org))

      {:ok, list}
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a document.

  ## Examples

      iex> update_document(document, %{field: new_value})
      {:ok, %Document{}}

      iex> update_document(document, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def update_document(%Document{} = document, attrs, org) do
  #   document
  #   |> Document.changeset(attrs)
  #   |> Repo.update(prefix: org)
  # end

  def update_document(%Document{} = document, attrs, org) do
    case attrs["attachments"] do
      nil ->
        update_document_without_attachments(document, attrs, org)

      _ ->
        update_document_with_attachments(document, attrs, org)
    end
  end

  def update_document_without_attachments(document, attrs, org) do
    document
    |> Document.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def update_document_with_attachments(document, attrs, org) do
    multi = Multi.new()

    multi
    |> Multi.run(:document, fn _repo, _changes ->
      update_document_without_attachments(document, attrs, org)
    end)
    |> Multi.run(:attachments, fn _repo, %{document: %{id: document_id}} ->
      list =
        attrs["attachments"]
        |> Enum.map(fn f -> %{file: f, document_id: document_id} end)
        |> Enum.map(&create_attachment(&1, org))

      {:ok, list}
    end)
    |> Repo.transaction()
  end

  @doc """
  Deletes a Document.

  ## Examples

      iex> delete_document(document)
      {:ok, %Document{}}

      iex> delete_document(document)
      {:error, %Ecto.Changeset{}}

  """
  def delete_document(%Document{} = document, org) do
    Repo.delete(document, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking document changes.

  ## Examples

      iex> change_document(document)
      %Ecto.Changeset{source: %Document{}}

  """
  def change_document(%Document{} = document) do
    Document.changeset(document, %{})
  end

  @doc """
  Returns the list of attachments.

  ## Examples

      iex> list_attachments()
      [%Attachment{}, ...]

  """
  def list_attachments(document_id, org) do
    Attachment
    |> where([a], a.document_id == ^document_id)
    |> Repo.all(prefix: org)
  end

  @doc """
  Gets a single attachment.

  Raises `Ecto.NoResultsError` if the Attachment does not exist.

  ## Examples

      iex> get_attachment!(123)
      %Attachment{}

      iex> get_attachment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attachment!(id, org), do: Repo.get!(Attachment, id, prefix: org)

  @doc """
  Creates a attachment.

  ## Examples

      iex> create_attachment(%{field: value})
      {:ok, %Attachment{}}

      iex> create_attachment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attachment(attrs \\ %{}, org) do
    %Attachment{}
    |> Attachment.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  @doc """
  Updates a attachment.

  ## Examples

      iex> update_attachment(attachment, %{field: new_value})
      {:ok, %Attachment{}}

      iex> update_attachment(attachment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attachment(%Attachment{} = attachment, attrs) do
    attachment
    |> Attachment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attachment.

  ## Examples

      iex> delete_attachment(attachment)
      {:ok, %Attachment{}}

      iex> delete_attachment(attachment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attachment(%Attachment{} = attachment, org) do
    Repo.delete(attachment, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attachment changes.

  ## Examples

      iex> change_attachment(attachment)
      %Ecto.Changeset{source: %Attachment{}}

  """
  def change_attachment(%Attachment{} = attachment) do
    Attachment.changeset(attachment, %{})
  end

  @doc """
  Returns the list of visas.

  ## Examples

      iex> list_visas()
      [%Visa{}, ...]

  """
  def list_visas(person, org) do
    Visa
    |> where([v], v.person_id == ^person.id)
    |> Repo.all(prefix: org)
    |> Repo.preload(type: [:lookup], attachments: [])
  end

  @doc """
  Gets a single visa.

  Raises `Ecto.NoResultsError` if the Visa does not exist.

  ## Examples

      iex> get_visa!(123)
      %Visa{}

      iex> get_visa!(456)
      ** (Ecto.NoResultsError)

  """
  def get_visa!(person, id, org) do
    Visa
    |> where([v], v.person_id == ^person.id)
    |> Repo.get!(id, prefix: org)
    |> Repo.preload([:attachments, :type])
  end

  @doc """
  Creates a visa.

  ## Examples

      iex> create_visa(%{field: value})
      {:ok, %Visa{}}

      iex> create_visa(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_visa(attrs \\ %{}, org) do
    case attrs["attachments"] do
      nil ->
        create_visa_without_attachments(attrs, org)

      _ ->
        create_visa_with_attachments(attrs, org)
    end
  end

  def create_visa_without_attachments(attrs, org) do
    %Visa{}
    |> Visa.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_visa_with_attachments(attrs, org) do
    multi = Multi.new()

    multi
    |> Multi.run(:visa, fn _repo, _changes ->
      create_visa_without_attachments(attrs, org)
    end)
    |> Multi.run(:attachments, fn _repo, %{visa: %{id: visa_id}} ->
      list =
        attrs["attachments"]
        |> Enum.map(fn f -> %{file: f, visa_id: visa_id} end)
        |> Enum.map(&create_attachment(&1, org))

      {:ok, list}
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a visa.

  ## Examples

      iex> update_visa(visa, %{field: new_value})
      {:ok, %Visa{}}

      iex> update_visa(visa, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_visa(%Visa{} = visa, attrs, org) do
    case attrs["attachments"] do
      nil ->
        update_visa_without_attachments(visa, attrs, org)

      _ ->
        update_visa_with_attachments(visa, attrs, org)
    end
  end

  def update_visa_without_attachments(visa, attrs, org) do
    visa
    |> Document.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def update_visa_with_attachments(visa, attrs, org) do
    multi = Multi.new()

    multi
    |> Multi.run(:visa, fn _repo, _changes ->
      update_document_without_attachments(visa, attrs, org)
    end)
    |> Multi.run(:attachments, fn _repo, %{visa: %{id: visa_id}} ->
      list =
        attrs["attachments"]
        |> Enum.map(fn f -> %{file: f, visa_id: visa_id} end)
        |> Enum.map(&create_attachment(&1, org))

      {:ok, list}
    end)
    |> Repo.transaction()
  end

  @doc """
  Deletes a Visa.

  ## Examples

      iex> delete_visa(visa)
      {:ok, %Visa{}}

      iex> delete_visa(visa)
      {:error, %Ecto.Changeset{}}

  """
  def delete_visa(%Visa{} = visa, org) do
    Repo.delete(visa, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking visa changes.

  ## Examples

      iex> change_visa(visa)
      %Ecto.Changeset{source: %Visa{}}

  """
  def change_visa(%Visa{} = visa) do
    Visa.changeset(visa, %{})
  end

  @doc """
  Returns the list of insurance_policies.

  ## Examples

      iex> list_insurance_policies()
      [%InsurancePolicy{}, ...]

  """
  def list_insurance_policies(person, org) do
    InsurancePolicy
    |> where([i], i.person_id == ^person.id)
    |> Repo.all(prefix: org)
    |> Repo.preload(type: [:lookup], attachments: [])
  end

  @doc """
  Gets a single insurance_policy.

  Raises `Ecto.NoResultsError` if the Insurance policy does not exist.

  ## Examples

      iex> get_insurance_policy!(123)
      %InsurancePolicy{}

      iex> get_insurance_policy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_insurance_policy!(person, id, org) do
    InsurancePolicy
    |> where([i], i.person_id == ^person.id)
    |> Repo.get!(id, prefix: org)
    |> Repo.preload([:attachments, :type])
  end

  @doc """
  Creates a insurance_policy.

  ## Examples

      iex> create_insurance_policy(%{field: value})
      {:ok, %InsurancePolicy{}}

      iex> create_insurance_policy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_insurance_policy(attrs \\ %{}, org) do
    case attrs["attachments"] do
      nil ->
        create_insurance_policy_without_attachments(attrs, org)

      _ ->
        create_insurance_policy_with_attachments(attrs, org)
    end
  end

  def create_insurance_policy_without_attachments(attrs, org) do
    %InsurancePolicy{}
    |> InsurancePolicy.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_insurance_policy_with_attachments(attrs, org) do
    multi = Multi.new()

    multi
    |> Multi.run(:visa, fn _repo, _changes ->
      create_insurance_policy_without_attachments(attrs, org)
    end)
    |> Multi.run(:attachments, fn _repo, %{visa: %{id: insurance_policies_id}} ->
      list =
        attrs["attachments"]
        |> Enum.map(fn f -> %{file: f, insurance_policies_id: insurance_policies_id} end)
        |> Enum.map(&create_attachment(&1, org))

      {:ok, list}
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a insurance_policy.

  ## Examples

      iex> update_insurance_policy(insurance_policy, %{field: new_value})
      {:ok, %InsurancePolicy{}}

      iex> update_insurance_policy(insurance_policy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_insurance_policy(%InsurancePolicy{} = insurance_policy, attrs, org) do
    case attrs["attachments"] do
      nil ->
        update_insurance_policy_without_attachments(insurance_policy, attrs, org)

      _ ->
        update_insurance_policy_with_attachments(insurance_policy, attrs, org)
    end
  end

  def update_insurance_policy_without_attachments(insurance_policy, attrs, org) do
    insurance_policy
    |> InsurancePolicy.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def update_insurance_policy_with_attachments(insurance_policy, attrs, org) do
    multi = Multi.new()

    multi
    |> Multi.run(:insurance_policy, fn _repo, _changes ->
      update_insurance_policy_without_attachments(insurance_policy, attrs, org)
    end)
    |> Multi.run(:attachments, fn _repo, %{insurance_policy: %{id: insurance_policy_id}} ->
      list =
        attrs["attachments"]
        |> Enum.map(fn f -> %{file: f, insurance_policy_id: insurance_policy_id} end)
        |> Enum.map(&create_attachment(&1, org))

      {:ok, list}
    end)
    |> Repo.transaction()
  end

  @doc """
  Deletes a InsurancePolicy.

  ## Examples

      iex> delete_insurance_policy(insurance_policy)
      {:ok, %InsurancePolicy{}}

      iex> delete_insurance_policy(insurance_policy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_insurance_policy(%InsurancePolicy{} = insurance_policy, org) do
    Repo.delete(insurance_policy, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking insurance_policy changes.

  ## Examples

      iex> change_insurance_policy(insurance_policy)
      %Ecto.Changeset{source: %InsurancePolicy{}}

  """
  def change_insurance_policy(%InsurancePolicy{} = insurance_policy) do
    InsurancePolicy.changeset(insurance_policy, %{})
  end

  @doc """
  Returns the list of addresses.

  ## Examples

      iex> list_addresses()
      [%Address{}, ...]

  """
  def list_addresses(person, org) do
    Address
    |> where([a], a.person_id == ^person.id)
    |> Repo.all( prefix: org)
    |> Repo.preload(:type)
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

      iex> get_address!(123)
      %Address{}

      iex> get_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address!(person, id, org) do
    Address
    |> where([a], a.person_id == ^person.id)
    |> Repo.get!(id, prefix: org)
    |> Repo.preload([:type])
  end
  @doc """
  Creates a address.

  ## Examples

      iex> create_address(%{field: value})
      {:ok, %Address{}}

      iex> create_address(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address(attrs \\ %{}, org) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  @doc """
  Updates a address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      {:ok, %Address{}}

      iex> update_address(address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs, org) do
    address
    |> Address.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a Address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

      iex> delete_address(address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address, org) do
    Repo.delete(address, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.

  ## Examples

      iex> change_address(address)
      %Ecto.Changeset{source: %Address{}}

  """
  def change_address(%Address{} = address) do
    Address.changeset(address, %{})
  end

end
