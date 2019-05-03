defmodule Sportegic.LookupTypes do
  @moduledoc """
  The LookupTypes context.
  """

  import Ecto.Query, warn: false
  alias Sportegic.Repo

  alias Sportegic.LookupTypes.Lookup
  alias Sportegic.LookupTypes.Seeds

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
    |> Repo.insert( prefix: org)
  end

  def create_default_lookups(org) do
    lookups = Seeds.get_default_lookups_list()
    list = Enum.map(lookups, &create_lookup(&1, org))
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
end
