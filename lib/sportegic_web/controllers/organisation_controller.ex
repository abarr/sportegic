defmodule SportegicWeb.OrganisationController do
  use SportegicWeb, :controller

  alias Sportegic.Accounts
  alias Sportegic.Accounts.Organisation
  alias Sportegic.Users
  alias Sportegic.LookupTypes

  plug :put_layout, "accounts.html"

  plug SportegicWeb.Plugs.Authenticate
  action_fallback Sportegic.FallbackController

  def index(%{assigns: %{current_user: user}} = conn, _params) do
    with {:ok, organisations} = Accounts.list_organisations_by_user(user.id) do
      case Enum.count(organisations) do
        # If this user is not associated with any orgs
        0 ->
          conn
          |> put_flash(
            :info,
            "You are not associated with an organisation. If you expected to login to an Organisation please contact the Account Administrator."
          )
          |> redirect(to: Routes.organisation_path(conn, :new))

        # If this User is associated with only one org
        1 ->
          {:ok, org} = Enum.fetch(organisations, 0)

          conn
          |> clear_flash()
          |> put_session(:organisation, org.prefix)
          |> put_session(:timezone, org.timezone)
          |> redirect(to: Routes.dashboard_path(conn, :index))

        # Many orgs - choose from list
        _ ->
          render(conn, "index.html", organisations: organisations)
      end
    end
  end

  def set_organisation(conn, %{"org" => org_prefix, "tz" => timezone}) do
    conn
    |> put_session(:organisation, org_prefix)
    |> put_session(:timezone, timezone)
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end

  def new(conn, _params) do
    changeset = Accounts.change_organisation(%Organisation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"organisation" => organisation_params}) do
    user_id = conn.assigns.current_user.id

    with {:ok, org} <- Accounts.create_organisation(organisation_params),
         {:ok, _orgs_users} <-
           Accounts.create_organisations_users(%{user_id: user_id, organisation_id: org.id}),
         {:ok, _lookup_types} <- LookupTypes.create_default_lookups(org.prefix),
         {:ok, _lookups} <- LookupTypes.create_default_lookup_types(org.prefix),
         {:ok, _roles} <- Users.create_default_roles(org.prefix),
         {:ok, _cats} <- Users.create_default_categories(org.prefix),
         {:ok, _perm} <- Users.create_default_permissions(org.prefix),
         {:ok, _role_permissions} <- Users.create_default_owner_permissions(org.prefix),
         {:ok, _role_permissions} <- Users.create_default_administrator_permissions(org.prefix) do
      conn
      |> put_session(:organisation, org.prefix)
      |> put_session(:timezone, org.timezone)
      |> put_flash(:info, "Organisation created successfully.")
      |> redirect(to: Routes.organisation_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = changeset
        |> Ecto.Changeset.delete_change(:home_city)
        |> Ecto.Changeset.delete_change(:timezone)
        |> IO.inspect

        msg = handle_error(changeset.errors)
        conn
        |> put_flash(:danger, msg)
        |> render("new.html", changeset: changeset)
    end
  end

  defp handle_error([{:prefix, { _message, _ }}]), do: "An Organisation with this name (Or similar) exists"
  defp handle_error(_all), do: "Something has gone wrong, please contact support"


  def show(conn, %{"id" => id}) do
    organisation = Accounts.get_organisation!(id)
    render(conn, "show.html", organisation: organisation)
  end
end
