defmodule SportegicWeb.SquadController do
  use SportegicWeb, :controller

  alias Sportegic.Squads
  alias Sportegic.Squads.Squad

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, _permissions) do
    squads = Squads.list_squads(org)
    render(conn, "index.html", squads: squads)
  end

  def new(conn, _params, _org, _permissions) do
    changeset = Squads.change_squad(%Squad{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"squad" => squad_params}, org, _permissions) do
    case Squads.create_squad(squad_params, org) do
      {:ok, squad} ->
        conn
        |> put_flash(:info, "Squad created successfully.")
        |> redirect(to: Routes.squad_path(conn, :show, squad))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, org, _permissions) do
    squad = Squads.get_squad!(id, org)
    render(conn, "show.html", squad: squad)
  end

  def edit(conn, %{"id" => id}, org, _permissions) do
    squad = Squads.get_squad!(id, org)
    changeset = Squads.change_squad(squad)
    render(conn, "edit.html", squad: squad, changeset: changeset)
  end

  def update(conn, %{"id" => id, "squad" => squad_params}, org, _permissions) do
    squad = Squads.get_squad!(id, org)

    case Squads.update_squad(squad, squad_params, org) do
      {:ok, squad} ->
        conn
        |> put_flash(:info, "Squad updated successfully.")
        |> redirect(to: Routes.squad_path(conn, :show, squad))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", squad: squad, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, org, _permissions) do
    squad = Squads.get_squad!(id, org)
    {:ok, _squad} = Squads.delete_squad(squad, org)

    conn
    |> put_flash(:info, "Squad deleted successfully.")
    |> redirect(to: Routes.squad_path(conn, :index))
  end

  def add_members(conn, %{"id" => id, "squad_members" => squad_members}, org, _permissions) do

    squad = Squads.get_squad!(id, org)
    case Squads.create_squad_people(squad, squad_members, org) do
      :ok ->
        conn
        |> put_flash(:info, "Squad deleted successfully.")
        |> redirect(to: Routes.squad_path(conn, :show, squad))
      {:error, msg} ->
        conn
        |> put_flash(:danger, "Unable to add members. " <> msg)
        |> redirect(to: Routes.squad_path(conn, :show, squad))
      end
  end

  def remove_member(conn, %{"person_id" => person_id, "squad_id" => squad_id} ,org, _permissions) do
    case Squads.get_squad_person(person_id, squad_id, org) do
      {:ok, sp} ->
        Squads.delete_squad_person(sp, org)
        squad = Squads.get_squad!(squad_id, org)
        conn
        |> put_flash(:info, "Squad updated successfully.")
        |> redirect(to: Routes.squad_path(conn, :show, squad))
      error ->
        IO.inspect(error)
        squad = Squads.get_squad!(squad_id, org)
        conn
        |> put_flash(:danger, "Unable to remove members")
        |> redirect(to: Routes.squad_path(conn, :show, squad))
    end

  end

end
