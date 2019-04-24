defmodule SportegicWeb.RoleController do
  use SportegicWeb, :controller

  alias Sportegic.Profiles
  alias Sportegic.Profiles.Role

  plug SportegicWeb.Plugs.Authenticate

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org) do
    roles = Profiles.list_roles(org)
    render(conn, "index.html", roles: roles)
  end

  def new(conn, _params, org) do
    changeset = Profiles.change_role(%Role{})
    permissions = Profiles.list_permissions(org)
    render(conn, "new.html", changeset: changeset, permissions: permissions)
  end

  def create(conn, %{"role" => role_params} = params, org) do
    IO.inspect(params)
    case Profiles.create_role(role_params, org) do
      {:ok, role} ->
        conn
        |> put_flash(:info, "Role created successfully.")
        |> redirect(to: Routes.role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, org) do
    role = Profiles.get_role!(id, org)
    render(conn, "show.html", role: role)
  end

  def edit(conn, %{"id" => id}, org) do
    role = Profiles.get_role!(id, org)
    changeset = Profiles.change_role(role)
    render(conn, "edit.html", role: role, changeset: changeset)
  end

  def update(conn, %{"id" => id, "role" => role_params}, org) do
    role = Profiles.get_role!(id, org)

    case Profiles.update_role(role, role_params, org) do
      {:ok, role} ->
        conn
        |> put_flash(:info, "Role updated successfully.")
        |> redirect(to: Routes.role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", role: role, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, org) do
    role = Profiles.get_role!(id, org)
    {:ok, _role} = Profiles.delete_role(role, org)

    conn
    |> put_flash(:info, "Role deleted successfully.")
    |> redirect(to: Routes.role_path(conn, :index))
  end
end
