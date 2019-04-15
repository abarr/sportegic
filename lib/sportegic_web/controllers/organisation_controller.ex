defmodule SportegicWeb.OrganisationController do
  use SportegicWeb, :controller

  alias Sportegic.Accounts
  alias Sportegic.Accounts.Organisation

  plug :put_layout, "accounts.html"

  def index(conn, _params) do
    organisations = Accounts.list_organisations()
    render(conn, "index.html", organisations: organisations)
  end

  def new(conn, _params) do
    changeset = Accounts.change_organisation(%Organisation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"organisation" => organisation_params}) do
    case Accounts.create_organisation(organisation_params) do
      {:ok, organisation} ->
        conn
        |> put_flash(:info, "Organisation created successfully.")
        |> redirect(to: Routes.organisation_path(conn, :show, organisation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organisation = Accounts.get_organisation!(id)
    render(conn, "show.html", organisation: organisation)
  end
  
end
