defmodule Sportegic.Notes do
  @moduledoc """
  The Notes context.
  """

  import Ecto.Query, warn: false
  alias __MODULE__
  alias Sportegic.Repo

  alias Sportegic.Notes.Note
  alias Sportegic.Notes.NoteType
  alias Sportegic.LookupTypes.Type

  @doc """
  Returns the list of notes.

  ## Examples

      iex> list_notes()
      [%Note{}, ...]

  """
  def list_notes(org) do
    Note
    |> Repo.all(prefix: org)
    |> Repo.preload(:types)
    |> IO.inspect()
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
  def get_note!(id, org), do: Repo.get!(Note, id, prefix: org)

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
  def create_note_type(attrs \\ %{}, org) do
    %NoteType{}
    |> NoteType.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_note_type(note, tag_text, org) when is_binary(tag_text) do
    IO.puts("HERE")

    case Repo.get_by(Type, %{name: tag_text}, prefix: org) do
      type ->
        NoteType.changeset(%NoteType{}, %{
          note_id: note.id,
          type_id: type.id
        })
        |> Repo.insert!(prefix: org)

      _ ->
        {:error, "Type does not exist"}
    end
  end

  def create_note_types(note, tags_list, org) when is_list(tags_list) do
    Enum.each(tags_list, &create_note_type(note, &1, org))
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
end
