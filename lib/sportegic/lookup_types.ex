defmodule Sportegic.LookupTypes do
  @moduledoc """
  The LookupTypes context.
  """

  import Ecto.Query, warn: false
  alias Sportegic.Repo

  alias Sportegic.LookupTypes.Lookup
  alias Sportegic.LookupTypes.Seeds
  alias Sportegic.LookupTypes.Type

  @doc """
  Returns the list of lookups.

  ## Examples

      iex> list_lookups()
      [%Lookup{}, ...]

  """
  def list_lookups(org) do
    Repo.all(Lookup, prefix: org)
  end

  @doc """
  Gets a single lookup.

  Raises `Ecto.NoResultsError` if the Lookup does not exist.

  ## Examples

      iex> get_lookup!(123)
      %Lookup{}

      iex> get_lookup!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lookup!(id, org), do: Repo.get!(Lookup, id, prefix: org)

  def get_lookup_by_name!(name, org) when is_binary(name) do
    Repo.get_by!(Lookup, [name: name], prefix: org)
  end

  @doc """
  Creates a lookup.

  ## Examples

      iex> create_lookup(%{field: value})
      {:ok, %Lookup{}}

      iex> create_lookup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lookup(attrs \\ %{}, org) do
    %Lookup{}
    |> Lookup.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_default_lookups(org) do
    lookups = Seeds.get_default_lookups_list()
    list = Enum.map(lookups, &create_lookup(&1, org))
    {:ok, list}
  end

  def create_default_lookup_types(org) do
    list =
      Seeds.get_default_document_types()
      |> Enum.concat(Seeds.get_default_visa_types())
      |> Enum.concat(Seeds.get_default_insurance_types())
      |> Enum.concat(Seeds.get_default_vehicle_types())
      |> Enum.concat(Seeds.get_default_notes_tags())
      |> Enum.map(&create_type(&1, org))

    {:ok, list}
  end

  @doc """
  Updates a lookup.

  ## Examples

      iex> update_lookup(lookup, %{field: new_value})
      {:ok, %Lookup{}}

      iex> update_lookup(lookup, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lookup(%Lookup{} = lookup, attrs, org) do
    lookup
    |> Lookup.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a Lookup.

  ## Examples

      iex> delete_lookup(lookup)
      {:ok, %Lookup{}}

      iex> delete_lookup(lookup)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lookup(%Lookup{} = lookup, org) do
    Repo.delete(lookup, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lookup changes.

  ## Examples

      iex> change_lookup(lookup)
      %Ecto.Changeset{source: %Lookup{}}

  """
  def change_lookup(%Lookup{} = lookup) do
    Lookup.changeset(lookup, %{})
  end

  @doc """
  Returns the list of types.

  ## Examples

      iex> list_types()
      [%Type{}, ...]

  """
  def list_types(lookup, org) do
    Type
    |> where([t], t.lookup_id == ^lookup.id)
    |> Repo.all(prefix: org)
    |> Repo.preload(:lookup)
  end

  @doc """
  Gets a single type.

  Raises `Ecto.NoResultsError` if the Type does not exist.

  ## Examples

      iex> get_type!(123)
      %Type{}

      iex> get_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_type!(lookup, id, org) do
    Type
    |> where([t], t.lookup_id == ^lookup.id)
    |> Repo.get!(id, prefix: org)
  end

  def get_type_by_name!(name, org) when is_binary(name) do
    Type
    |> Repo.get_by!([name: name], prefix: org)
  end

  @doc """
  Creates a type.

  ## Examples

      iex> create_type(%{field: value})
      {:ok, %Type{}}

      iex> create_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_type(attrs \\ %{}, org) do
    %Type{}
    |> Type.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  @doc """
  Updates a type.

  ## Examples

      iex> update_type(type, %{field: new_value})
      {:ok, %Type{}}

      iex> update_type(type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_type(%Type{} = type, attrs, org) do
    type
    |> Type.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a Type.

  ## Examples

      iex> delete_type(type)
      {:ok, %Type{}}

      iex> delete_type(type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_type(%Type{} = type, org) do
    Repo.delete(type, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking type changes.

  ## Examples

      iex> change_type(type)
      %Ecto.Changeset{source: %Type{}}

  """
  def change_type(%Type{} = type) do
    Type.changeset(type, %{})
  end
end
