defmodule Sportegic.Notes do
  @moduledoc """
  The Notes context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Sportegic.Repo
  alias __MODULE__
  alias Sportegic.Notes.Note
  alias Sportegic.Notes.NoteType
  alias Sportegic.LookupTypes
  alias Sportegic.LookupTypes.Type
  alias Sportegic.Notes.NotePerson
  alias Sportegic.People
  alias Sportegic.Notes.Comment

  @doc """
  Returns the list of notes.

  ## Examples

      iex> list_notes()
      [%Note{}, ...]

  """
  def list_notes(org) do
    Note
    |> order_by([n], desc: n.inserted_at)
    |> Repo.all(prefix: org)
    |> Repo.preload([:types, :user, :people])
  end

  def list_notes(search_term, org) do
    note_ids = Notes.Search.run(search_term, org)

    from(note in Note,
      where: note.id in ^note_ids,
      select: note
    )
    |> Repo.all(prefix: org)
    |> Repo.preload([:types, :user, :people])
  end

  @doc """
  Gets a single note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_note!(123)
      %Note{}

      iex> get_note!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note!(id, org) do
    Note
    |> Repo.get!(id, prefix: org)
    |> Repo.preload([:types, :user, :people, comments: [:user]])
  end

  @doc """
  Creates a note.

  ## Examples

      iex> create_note(%{field: value})
      {:ok, %Note{}}

      iex> create_note(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_note(attrs \\ %{}, org) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  @doc """
  Updates a note.

  ## Examples

      iex> update_note(note, %{field: new_value})
      {:ok, %Note{}}

      iex> update_note(note, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note(%Note{} = note, attrs, org) do
    note
    |> Note.changeset(attrs)
    |> Changeset.put_assoc(:types, Notes.get_updated_note_tags(attrs["types"], org))
    |> Changeset.put_assoc(:people, Notes.get_updated_people_tags(attrs["people"], org))
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a Note.

  ## Examples

      iex> delete_note(note)
      {:ok, %Note{}}

      iex> delete_note(note)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note(%Note{} = note, org) do
    Repo.delete(note, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.

  ## Examples

      iex> change_note(note)
      %Ecto.Changeset{source: %Note{}}

  """
  def change_note(%Note{} = note) do
    Note.changeset(note, %{})
  end

  @doc """
  Returns the list of note_type.

  ## Examples

      iex> list_note_type()
      [%NoteType{}, ...]

  """
  def list_note_type(org) do
    Repo.all(NoteType, prefix: org)
  end

  @doc """
  Gets a single note_type.

  Raises `Ecto.NoResultsError` if the Note type does not exist.

  ## Examples

      iex> get_note_type!(123)
      %NoteType{}

      iex> get_note_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note_type!(id, org), do: Repo.get!(NoteType, id, prefix: org)

  @doc """
  Creates a note_type.

  ## Examples

      iex> create_note_type(%{field: value})
      {:ok, %NoteType{}}

      iex> create_note_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_note_type(attrs \\ %{}, org) do
  #   %NoteType{}
  #   |> NoteType.changeset(attrs)
  #   |> Repo.insert(prefix: org)
  # end

  def create_note_type(note, tag_text, org) when is_binary(tag_text) do
    case Repo.get_by(Type, %{name: tag_text}, prefix: org) do
      type when is_map(type) ->
        NoteType.changeset(%NoteType{}, %{
          note_id: note.id,
          type_id: type.id
        })
        |> Repo.insert!(prefix: org)

      _ ->
        {:error, "Tag does not exist"}
    end
  end

  def create_note_types(note, tags_list, org) when is_list(tags_list) do
    Enum.each(tags_list, &create_note_type(note, &1, org))
  end

  def create_note_people(note, people_list, org) when is_list(people_list) do
    Enum.each(people_list, &create_note_person(note, &1, org))
  end

  @doc """
  Updates a note_type.

  ## Examples

      iex> update_note_type(note_type, %{field: new_value})
      {:ok, %NoteType{}}

      iex> update_note_type(note_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note_type(%NoteType{} = note_type, attrs, org) do
    note_type
    |> NoteType.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def get_updated_note_tags(updated_tags, org) when is_list(updated_tags) do
    Enum.map(updated_tags, &LookupTypes.get_type_by_name!(&1, org))
  end

  def get_updated_people_tags(updated_people \\ [], org) when is_list(updated_people) do
    updated_people
    |> Enum.map(&People.get_person_by_name_dob(&1, org))
    |> IO.inspect()
  end

  @doc """
  Deletes a NoteType.

  ## Examples

      iex> delete_note_type(note_type)
      {:ok, %NoteType{}}

      iex> delete_note_type(note_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note_type(%NoteType{} = note_type, org) do
    Repo.delete(note_type, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note_type changes.

  ## Examples

      iex> change_note_type(note_type)
      %Ecto.Changeset{source: %NoteType{}}

  """
  def change_note_type(%NoteType{} = note_type) do
    NoteType.changeset(note_type, %{})
  end

  @doc """
  Returns the list of notes_people.

  ## Examples

      iex> list_notes_people()
      [%NotePerson{}, ...]

  """
  def list_notes_people(org) do
    Repo.all(NotePerson, prefix: org)
  end

  @doc """
  Gets a single note_person.

  Raises `Ecto.NoResultsError` if the Note person does not exist.

  ## Examples

      iex> get_note_person!(123)
      %NotePerson{}

      iex> get_note_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note_person!(id, org), do: Repo.get!(NotePerson, id, prefix: org)

  @doc """
  Creates a note_person.

  ## Examples

      iex> create_note_person(%{field: value})
      {:ok, %NotePerson{}}

      iex> create_note_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_note_person(attrs \\ %{}, org) do
  #   %NotePerson{}
  #   |> NotePerson.changeset(attrs)
  #   |> Repo.insert(prefix: org)
  # end

  def create_note_person(note, person_text, org) when is_binary(person_text) do
    case People.get_person_by_name_dob(person_text, org) do
      person when is_map(person) ->
        NotePerson.changeset(%NotePerson{}, %{
          note_id: note.id,
          person_id: person.id
        })
        |> Repo.insert!(prefix: org)

      _ ->
        {:error, "error"}
    end
  end

  @doc """
  Updates a note_person.

  ## Examples

      iex> update_note_person(note_person, %{field: new_value})
      {:ok, %NotePerson{}}

      iex> update_note_person(note_person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note_person(%NotePerson{} = note_person, attrs, org) do
    note_person
    |> NotePerson.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a NotePerson.

  ## Examples

      iex> delete_note_person(note_person)
      {:ok, %NotePerson{}}

      iex> delete_note_person(note_person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note_person(%NotePerson{} = note_person, org) do
    Repo.delete(note_person, prfeix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note_person changes.

  ## Examples

      iex> change_note_person(note_person)
      %Ecto.Changeset{source: %NotePerson{}}

  """
  def change_note_person(%NotePerson{} = note_person) do
    NotePerson.changeset(note_person, %{})
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(note_id, user_id, attrs \\ %{}, org) do
    attrs =
      attrs
      |> Map.put("user_id", user_id)
      |> Map.put("note_id", note_id)

    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def get_comment!(id, org) do
    Comment
    |> Repo.get!(id, prefix: org)
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment, org) do
    Repo.delete(comment, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
