defmodule Sportegic.Accounts do
  import Ecto.Query, warn: false

  alias Sportegic.Repo
  alias Sportegic.Accounts.{User, Organisation, OrganisationsUsers}

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    user = Repo.get(User, id)
    {:ok, user}
  end

  def get_user_by_email(email) do
    user = Repo.get_by(User, email: email)
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

  # ORGANISATIONS
  def list_organisations do
    Repo.all(Organisation)
  end

  def get_organisation!(id), do: Repo.get!(Organisation, id)

  def create_organisation(attrs \\ %{}) do
    %Organisation{}
    |> Organisation.changeset(attrs)
    |> Repo.insert()
  end

  def update_organisation(%Organisation{} = organisation, attrs) do
    organisation
    |> Organisation.changeset(attrs)
    |> Repo.update()
  end

  def delete_organisation(%Organisation{} = organisation) do
    Repo.delete(organisation)
  end

  def change_organisation(%Organisation{} = organisation) do
    Organisation.changeset(organisation, %{})
  end

  def list_organisations_users do
    Repo.all(OrganisationsUsers)
  end

  def get_organisations_users!(id), do: Repo.get!(OrganisationsUsers, id)

  def create_organisations_users(attrs \\ %{}) do
    %OrganisationsUsers{}
    |> OrganisationsUsers.changeset(attrs)
    |> Repo.insert()
  end

  def update_organisations_users(%OrganisationsUsers{} = organisations_users, attrs) do
    organisations_users
    |> OrganisationsUsers.changeset(attrs)
    |> Repo.update()
  end

  def delete_organisations_users(%OrganisationsUsers{} = organisations_users) do
    Repo.delete(organisations_users)
  end

  def change_organisations_users(%OrganisationsUsers{} = organisations_users) do
    OrganisationsUsers.changeset(organisations_users, %{})
  end

  # SESSIONS
  def authenticate_session(user, password) do
    Argon2.check_pass(user, password)
  end

  # def create_session(attrs \\ %{}) do
  #   raise "TODO"
  # end

  # def delete_session(%Session{} = session) do
  #   raise "TODO"
  # end
end
