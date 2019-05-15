defmodule SportegicWeb.PersonController do
  use SportegicWeb, :controller

  alias Sportegic.People
  alias Sportegic.People.Person

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, _org, _permissions) do
    render(conn, "index.html")
  end

  def new(conn, _params, _org, permissions) do
    with :ok <- Bodyguard.permit(People, "create:people_permissions", :person, permissions) do
      changeset = People.change_person(%Person{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"person" => person_params}, org, permissions) do
    with :ok <- Bodyguard.permit(People, "create:people_permissions", :person, permissions) do
      case People.create_person(person_params, org) do
        {:ok, person} ->
          conn
          |> put_flash(:success, "Person created successfully.")
          |> redirect(to: Routes.person_path(conn, :show, person))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:danger, "There is an error on the page")
          |> render("new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}, org, _permissions) do
    person = People.get_person!(id, org)
    render(conn, "show.html", person: person)
  end

  def edit(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(People, "edit:people_permissions", :person, permissions) do
      person = People.get_person!(id, org)
      changeset = People.change_person(person)
      render(conn, "edit.html", person: person, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "person" => person_params}, org, permissions) do
    with :ok <- Bodyguard.permit(People, "edit:people_permissions", :person, permissions) do
      person = People.get_person!(id, org)

      case People.update_person(person, person_params, org) do
        {:ok, person} ->
          conn
          |> put_flash(:success, "Person updated successfully.")
          |> redirect(to: Routes.person_path(conn, :show, person))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:danger, "Unable to make changes to this person")
          |> render("edit.html", person: person, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}, permissions, org, permissions) do
    with :ok <- Bodyguard.permit(People, "delete:people_permissions", :person, permissions) do
      person = People.get_person!(id, org)
      {:ok, _person} = People.delete_person(person, org)

      conn
      |> put_flash(:danger, "Person deleted successfully.")
      |> redirect(to: Routes.person_path(conn, :index))
    end
  end
end
