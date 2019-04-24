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
    render(conn, "new.html", changeset: changeset, permissions: permissions, role_permissions: [])
  end

  def create(conn, %{"role" => role_params}, org) do
    {role, permissions} = Map.split(role_params, ["name", "description"])

    permissions =
      permissions
      |> Enum.filter(fn {_k, v} -> v == "true" end)
      |> Map.new()
      |> Map.keys()

    with {:ok, role} <- Profiles.create_role(role, org),
         {:ok, _role_perissions} <- Profiles.create_role_permissions(role.id, permissions, org) do
      conn
      |> put_flash(:success, "Your new Role has been successfully created.")
      |> redirect(to: Routes.role_path(conn, :index))
    else
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
    permissions = Profiles.list_permissions(org)

    case role.id do
      1 ->
        roles = Profiles.list_roles(org)

        conn
        |> put_flash(:info, "The Owner Role cannot be edited.")
        |> render("index.html", roles: roles)

      _ ->
        render(conn, "edit.html",
          role: role,
          changeset: changeset,
          permissions: permissions
        )
    end
  end

  def update(conn, %{"id" => id, "role" => params} = data, org) do
    role = Profiles.get_role!(id, org)
    {role_params, permissions} = Map.split(params, ["name", "description"])

    permissions =
      permissions
      |> Enum.filter(fn {_k, v} -> v == "true" end)
      |> Map.new()
      |> Map.keys()
      |> Profiles.list_permissions(org)

    case Profiles.update_role(role, role_params, permissions, org) do
      {:ok, _role} ->
        conn
        |> put_flash(:success, "Role updated successfully.")
        |> redirect(to: Routes.role_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        permissions = Profiles.list_permissions(org)
        render(conn, "edit.html", role: role, changeset: changeset, permissions: permissions)
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
