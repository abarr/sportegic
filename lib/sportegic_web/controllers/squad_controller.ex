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
end
