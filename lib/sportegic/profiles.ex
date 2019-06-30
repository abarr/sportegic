defmodule Sportegic.Profiles do
  @moduledoc """
  The People context.
  """
  import Ecto.Query, warn: false
  use Timex
  alias Sportegic.Repo
  alias Sportegic.People
  alias Sportegic.Profiles
  alias Sportegic.Profiles.{AthleteProfile, PlayingPosition, Performance}
  alias Sportegic.LookupTypes
  alias Sportegic.LookupTypes.Type
  alias Sportegic.Users.User
  

  @doc """
  Returns the list of athletic_profiles.

  ## Examples

      iex> list_athletic_profiles()
      [%AthleticProfile{}, ...]

  """
  def list_athlete_profiles(%{id: person_id}, org) do
    AthleteProfile
    |> Repo.get_by!( [person_id: person_id], prefix: org)
    |> Repo.preload( [performances: [:user, :context, :performance_area, :rating]])
  end

 
  @doc """
  Gets a single athletic_profile.

  Raises `Ecto.NoResultsError` if the Athletic profile does not exist.

  ## Examples

      iex> get_athletic_profile!(123)
      %AthleticProfile{}

      iex> get_athletic_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_athlete_profile!(id, org) when is_binary(id), do: Repo.get!(AthleteProfile, id, prefix: org)
  def get_athlete_profile(person, org) when is_map(person), do: get_athlete_profile(person.id, org)
  def get_athlete_profile(person_id, org) when is_binary(person_id) do
    case People.get_person_athlete_profile!(person_id, org) do
      %{athlete_profile: athlete_profile } -> athlete_profile
      error -> error
    end
  end


  def update_athlete_profile_postions(person_id, positions, org) do
    profile = Profiles.get_athlete_profile(person_id, org)

    ids = positions
    |> Enum.map(fn p -> 
      LookupTypes.get_type_id_by_name!(p.name, org)
    end)
    |> Enum.map(fn id -> 
      PlayingPosition
      |> PlayingPosition.changeset(%{profile_id: profile.id, type_id: id})
    end)
    |> IO.inspect
    
  end

  def load_positions(ids) do
    case ids || [] do
      [] -> []
      ids -> Repo.all from t in Type, where: t.id in ^ids
    end
  end


  @doc """
  Creates a athletic_profile.

  ## Examples

      iex> create_athletic_profile(%{field: value})
      {:ok, %AthleticProfile{}}

      iex> create_athletic_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_athlete_profile(person, org) do
    %AthleteProfile{}
    |> AthleteProfile.changeset(%{person_id: person.id})
    |> Repo.insert(prefix: org)
  end

  @doc """
  Updates a athletic_profile.

  ## Examples

      iex> update_athletic_profile(athletic_profile, %{field: new_value})
      {:ok, %AthleticProfile{}}

      iex> update_athletic_profile(athletic_profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_athlete_profile(%AthleteProfile{} = athlete_profile, attrs, org) do
    athlete_profile
    |> AthleteProfile.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a AthleticProfile.

  ## Examples

      iex> delete_athletic_profile(athletic_profile)
      {:ok, %AthleticProfile{}}

      iex> delete_athletic_profile(athletic_profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_athlete_profile(%AthleteProfile{} = athlete_profile, org) do
    Repo.delete(athlete_profile, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking athletic_profile changes.

  ## Examples

      iex> change_athletic_profile(athletic_profile)
      %Ecto.Changeset{source: %AthleticProfile{}}

  """
  def change_athlete_profile(%AthleteProfile{} = athlete_profile) do
    AthleteProfile.changeset(athlete_profile, %{})
  end



  @doc """
  Returns the list of profiles_position.

  ## Examples

      iex> list_profiles_position()
      [%ProfilePosition{}, ...]

  """
  def list_playing_position(person, org) do
    PlayingPosition
    |> where([pp], pp.person_id == ^person.id)
    |> Repo.all(prefix: org)
  end


  @doc """
  Creates a profile_position.

  ## Examples

      iex> create_profile_position(%{field: value})
      {:ok, %ProfilePosition{}}

      iex> create_profile_position(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_playing_position(attrs \\ %{}, org) do
    %PlayingPosition{}
    |> PlayingPosition.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_playing_position(person, position_name, org) when is_binary(position_name) do
    case Repo.get_by(Type, %{name: position_name}, prefix: org) do
      type when is_map(type) ->
        PlayingPosition.changeset(%PlayingPosition{}, %{
          athlete_profiles_id: person.athlete_profile.id,
          type_id: type.id
        })
        |> Repo.insert!(prefix: org)

      _ ->
        {:error, "Position does not exist"}
    end
  end

  def create_athlete_profile_positions(person, positions_list, org) when is_list(positions_list) do
    Enum.each(positions_list, &create_playing_position(person, &1, org))
  end





  @doc """
  Updates a profile_position.

  ## Examples

      iex> update_profile_position(profile_position, %{field: new_value})
      {:ok, %ProfilePosition{}}

      iex> update_profile_position(profile_position, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_athlete_profile_playing_position(%PlayingPosition{} = athlete_profile_playing_position, attrs) do
    athlete_profile_playing_position
    |> PlayingPosition.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProfilePosition.

  ## Examples

      iex> delete_profile_position(profile_position)
      {:ok, %ProfilePosition{}}

      iex> delete_profile_position(profile_position)
      {:error, %Ecto.Changeset{}}

  """
  def delete_athlete_profile_playing_position(%PlayingPosition{} = athlete_profile_playing_position) do
    Repo.delete(athlete_profile_playing_position)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile_position changes.

  ## Examples

      iex> change_profile_position(profile_position)
      %Ecto.Changeset{source: %ProfilePosition{}}

  """
  def change_athlete_profile_playing_position(%PlayingPosition{} = athlete_profile_playing_position) do
    PlayingPosition.changeset(athlete_profile_playing_position, %{})
  end

  

  @doc """
  Returns the list of performances.

  ## Examples

      iex> list_performances()
      [%Performance{}, ...]

  """
  def list_performances(org) do
    Repo.all(Performance, prefix: org)
  end

  @doc """
  Gets a single performance.

  Raises `Ecto.NoResultsError` if the Performance does not exist.

  ## Examples

      iex> get_performance!(123)
      %Performance{}

      iex> get_performance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_performance!(id, org), do: Repo.get!(Performance, id, prefix: org)

  def get_performance!(id, org) when is_binary(id), do: Repo.get!(Performance, id, prefix: org)
  def get_performance(person, org) when is_map(person), do: get_performance(person.athlete_profile.id, org)
  def get_performance(profile_id, org) when is_binary(profile_id) do
    case People.get_person_athlete_profile!(profile_id, org) do
      %{athlete_profile: athlete_profile } -> athlete_profile.performances
      error -> error
    end
  end

  @doc """
  Creates a performance.

  ## Examples

      iex> create_performance(%{field: value})
      {:ok, %Performance{}}

      iex> create_performance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_performance(attrs \\ %{}, org) do
    %Performance{}
    |> Performance.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  @doc """
  Updates a performance.

  ## Examples

      iex> update_performance(performance, %{field: new_value})
      {:ok, %Performance{}}

      iex> update_performance(performance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_performance(%Performance{} = performance, attrs, org) do
    performance
    |> Performance.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a Performance.

  ## Examples

      iex> delete_performance(performance)
      {:ok, %Performance{}}

      iex> delete_performance(performance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_performance(%Performance{} = performance, org) do
    Repo.delete(performance, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking performance changes.

  ## Examples

      iex> change_performance(performance)
      %Ecto.Changeset{source: %Performance{}}

  """
  def change_performance(%Performance{} = performance) do
    Performance.changeset(performance, %{})
  end
end
