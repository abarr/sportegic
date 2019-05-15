defmodule Sportegic.People do
  @moduledoc """
  The People context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Sportegic.Repo
  alias Sportegic.People.Person
  alias Sportegic.People.Document
  alias Sportegic.People.Attachment

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
    Person
    |> Repo.get!(id, prefix: org)
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
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert(prefix: org)
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
      list = attrs["attachments"]
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
  def update_document(%Document{} = document, attrs, org) do
    document
    |> Document.changeset(attrs)
    |> Repo.update(prefix: org)
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
  def delete_attachment(%Attachment{} = attachment) do
    Repo.delete(attachment)
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
end
