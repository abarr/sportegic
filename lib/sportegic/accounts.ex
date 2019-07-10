defmodule Sportegic.Accounts do
  import Ecto.Query, warn: false

  alias Sportegic.Repo
  alias Sportegic.Accounts
  alias Sportegic.Accounts.{User, Organisation, OrganisationsUsers, Rsvp}
  alias Sportegic.Users

  defdelegate authorize(action, user, params), to: Sportegic.Users.Authorisation

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    user =
      User
      |> Repo.get(id)
      |> Repo.preload(:organisations)

    {:ok, user}
  end

  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) |> Repo.preload(:organisations) do
      nil -> {:error, "No records by this name"}
      {:error, msg} -> {:error, msg}
      user -> {:ok, user}
    end
  end

  def get_user_status(email, org) do
    case get_user_by_email(email) do
      {:ok, user} ->
        case Enum.find(user.organisations, fn o -> o.prefix == org end) do
          nil ->
            # Check if user exists but is disabled
            case Users.get_user(user.id, org) do
              # User exists but they are not assoc with org
              {:ok, nil} -> {:new}
              # Account exists but they are disabled
              {:ok, _user} -> {:exists_disabled}
              _ -> {:error, "Error checking if user exists for organisation"}
            end

          # Account exists and they are already associated with org
          _ ->
            {:exists}
        end

      # No account new User
      _ ->
        {:new}
    end
  end

  def get_or_create_user(attrs \\ %{}) do
    case Accounts.get_user_by_email(attrs["email"]) do
      {:ok, account} -> {:ok, account}
      _ -> Accounts.create_user(attrs)
    end
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

  def list_organisations_by_user(user_id) do
    {:ok, user} = Accounts.get_user(user_id)
    organisations = Repo.all(Ecto.assoc(user, :organisations))
    {:ok, organisations}
  end

  def get_organisation!(id), do: Repo.get!(Organisation, id)

  def get_organisation_by_prefix(prefix) do
    org =
      Organisation
      |> Repo.get_by(prefix: prefix)

    {:ok, org}
  end

  def create_organisation(attrs) do
    case %Organisation{}
          |> Organisation.changeset(attrs)
          |> Repo.insert() do
    
      {:ok, org} -> 
        case Triplex.create(org.prefix) do
          {:ok, _tenant} ->
            {:ok, org}
    
          {:error, msg} ->
            IO.inspect(msg, label: "TRIPLEX ERROR")
            {:error, msg}
        end
      {:error, error} -> {:error, error}
    end
    
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

  def get_organisations_users(user_id, org_id) do
    case Repo.get_by(OrganisationsUsers, organisation_id: org_id, user_id: user_id) do
      nil -> {:error, "No records exist"}
      {:error, msg} -> {:error, msg}
      org_user -> {:ok, org_user}
    end
  end

  def create_organisations_users(attrs \\ %{}) do
    orgs_users =
      %OrganisationsUsers{}
      |> OrganisationsUsers.changeset(attrs)
      |> Repo.insert()

    {:ok, orgs_users}
  end

  def update_organisations_users(%OrganisationsUsers{} = organisations_users, attrs) do
    organisations_users
    |> OrganisationsUsers.changeset(attrs)
    |> Repo.update()
  end

  def delete_organisations_users(%OrganisationsUsers{} = organisations_users) do
    organisations_users
    |> Repo.delete()
  end

  def change_organisations_users(%OrganisationsUsers{} = organisations_users) do
    OrganisationsUsers.changeset(organisations_users, %{})
  end

  # SESSIONS
  def authenticate_session(user, password) do
    Argon2.check_pass(user, password)
  end

  # RSVP
  def change_rsvp(%Rsvp{} = rsvp) do
    Rsvp.changeset(rsvp, %{})
  end
end
