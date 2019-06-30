defmodule Sportegic.Squads do
  @moduledoc """
  The Squads context.
  """

  import Ecto.Query, warn: false
  alias Sportegic.Repo
  alias Sportegic.Squads.{Squad, SquadPerson}
  alias Sportegic.People.Person

  defdelegate authorize(action, user, params), to: Sportegic.Users.Authorisation
  @doc """
  Returns the list of squads.

  ## Examples

      iex> list_squads()
      [%Squad{}, ...]

  """
  def list_squads(org) do
    Squad
    |> Repo.all( prefix: org)
    
  end

  @doc """
  Gets a single squad.

  Raises `Ecto.NoResultsError` if the Squad does not exist.

  ## Examples

      iex> get_squad!(123)
      %Squad{}

      iex> get_squad!(456)
      ** (Ecto.NoResultsError)

  """
  def get_squad!(id, org), do: Repo.get!(Squad, id, prefix: org) |> Repo.preload(:people)

  @doc """
  Creates a squad.

  ## Examples

      iex> create_squad(%{field: value})
      {:ok, %Squad{}}

      iex> create_squad(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_squad(attrs \\ %{}, org) do
    %Squad{}
    |> Squad.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  @doc """
  Updates a squad.

  ## Examples

      iex> update_squad(squad, %{field: new_value})
      {:ok, %Squad{}}

      iex> update_squad(squad, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_squad(%Squad{} = squad, attrs, org) do
    squad
    |> Squad.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a Squad.

  ## Examples

      iex> delete_squad(squad)
      {:ok, %Squad{}}

      iex> delete_squad(squad)
      {:error, %Ecto.Changeset{}}

  """
  def delete_squad(%Squad{} = squad, org) do
    Repo.delete(squad, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking squad changes.

  ## Examples

      iex> change_squad(squad)
      %Ecto.Changeset{source: %Squad{}}

  """
  def change_squad(%Squad{} = squad) do
    Squad.changeset(squad, %{})
  end

  

  @doc """
  Returns the list of squads_peoiple.

  ## Examples

      iex> list_squads_peoiple()
      [%SquadPerson{}, ...]

  """
  def list_squads_people(org) do
    Repo.all(SquadPerson, prefix: org)
  end

  @doc """
  Gets a single squad_person.

  Raises `Ecto.NoResultsError` if the Squad person does not exist.

  ## Examples

      iex> get_squad_person!(123)
      %SquadPerson{}

      iex> get_squad_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_squad_person!(id, org), do: Repo.get!(SquadPerson, id, prefix: org)

  def get_squad_person(person_id, squad_id, org) do
    case Repo.get_by(SquadPerson, [person_id: person_id, squad_id: squad_id], prefix: org) do
      nil -> {:error, "Unable to get Squad Person record"}
      sp -> {:ok, sp}
    end
  end
  @doc """
  Creates a squad_person.

  ## Examples

      iex> create_squad_person(%{field: value})
      {:ok, %SquadPerson{}}

      iex> create_squad_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_squad_person(attrs \\ %{}, org) do
    %SquadPerson{}
    |> SquadPerson.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_squad_person(squad, person_id, org) when is_binary(person_id) do
    case Repo.get_by(Person, %{id: person_id}, prefix: org) do
      person when is_map(person) ->
        SquadPerson.changeset(%SquadPerson{}, %{
          person_id: person.id,
          squad_id: squad.id
        })
        |> Repo.insert!(prefix: org)

      _ ->
        {:error, "Person does not exist"}
    end
  end

  def create_squad_people(squad, people_list, org) when is_list(people_list) do
    Enum.each(people_list, &create_squad_person(squad, &1, org))
  end

  @doc """
  Updates a squad_person.

  ## Examples

      iex> update_squad_person(squad_person, %{field: new_value})
      {:ok, %SquadPerson{}}

      iex> update_squad_person(squad_person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_squad_person(%SquadPerson{} = squad_person, attrs, org) do
    squad_person
    |> SquadPerson.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a SquadPerson.

  ## Examples

      iex> delete_squad_person(squad_person)
      {:ok, %SquadPerson{}}

      iex> delete_squad_person(squad_person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_squad_person(%SquadPerson{} = squad_person, org) do
    Repo.delete(squad_person, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking squad_person changes.

  ## Examples

      iex> change_squad_person(squad_person)
      %Ecto.Changeset{source: %SquadPerson{}}

  """
  def change_squad_person(%SquadPerson{} = squad_person) do
    SquadPerson.changeset(squad_person, %{})
  end

end
