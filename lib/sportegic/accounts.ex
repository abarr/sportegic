defmodule Sportegic.Accounts do
  import Ecto.Query, warn: false

  alias Sportegic.Repo
  alias Sportegic.Accounts.{User, Organisation}

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    user = Repo.get(User, id)
    {:ok, user}
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns the list of organisations.

  ## Examples

      iex> list_organisations()
      [%Organisation{}, ...]

  """
  def list_organisations do
    Repo.all(Organisation)
  end

  @doc """
  Gets a single organisation.

  Raises `Ecto.NoResultsError` if the Organisation does not exist.

  ## Examples

      iex> get_organisation!(123)
      %Organisation{}

      iex> get_organisation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organisation!(id), do: Repo.get!(Organisation, id)

  @doc """
  Creates a organisation.

  ## Examples

      iex> create_organisation(%{field: value})
      {:ok, %Organisation{}}

      iex> create_organisation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organisation(attrs \\ %{}) do
    %Organisation{}
    |> Organisation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organisation.

  ## Examples

      iex> update_organisation(organisation, %{field: new_value})
      {:ok, %Organisation{}}

      iex> update_organisation(organisation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organisation(%Organisation{} = organisation, attrs) do
    organisation
    |> Organisation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Organisation.

  ## Examples

      iex> delete_organisation(organisation)
      {:ok, %Organisation{}}

      iex> delete_organisation(organisation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organisation(%Organisation{} = organisation) do
    Repo.delete(organisation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organisation changes.

  ## Examples

      iex> change_organisation(organisation)
      %Ecto.Changeset{source: %Organisation{}}

  """
  def change_organisation(%Organisation{} = organisation) do
    Organisation.changeset(organisation, %{})
  end

  alias Sportegic.Accounts.OrganisationsUsers

  @doc """
  Returns the list of organisations_users.

  ## Examples

      iex> list_organisations_users()
      [%OrganisationsUsers{}, ...]

  """
  def list_organisations_users do
    Repo.all(OrganisationsUsers)
  end

  @doc """
  Gets a single organisations_users.

  Raises `Ecto.NoResultsError` if the Organisations users does not exist.

  ## Examples

      iex> get_organisations_users!(123)
      %OrganisationsUsers{}

      iex> get_organisations_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organisations_users!(id), do: Repo.get!(OrganisationsUsers, id)

  @doc """
  Creates a organisations_users.

  ## Examples

      iex> create_organisations_users(%{field: value})
      {:ok, %OrganisationsUsers{}}

      iex> create_organisations_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organisations_users(attrs \\ %{}) do
    %OrganisationsUsers{}
    |> OrganisationsUsers.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organisations_users.

  ## Examples

      iex> update_organisations_users(organisations_users, %{field: new_value})
      {:ok, %OrganisationsUsers{}}

      iex> update_organisations_users(organisations_users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organisations_users(%OrganisationsUsers{} = organisations_users, attrs) do
    organisations_users
    |> OrganisationsUsers.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrganisationsUsers.

  ## Examples

      iex> delete_organisations_users(organisations_users)
      {:ok, %OrganisationsUsers{}}

      iex> delete_organisations_users(organisations_users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organisations_users(%OrganisationsUsers{} = organisations_users) do
    Repo.delete(organisations_users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organisations_users changes.

  ## Examples

      iex> change_organisations_users(organisations_users)
      %Ecto.Changeset{source: %OrganisationsUsers{}}

  """
  def change_organisations_users(%OrganisationsUsers{} = organisations_users) do
    OrganisationsUsers.changeset(organisations_users, %{})
  end
end
