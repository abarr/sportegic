defmodule SportegicWeb.RoleController do
  use SportegicWeb, :controller

  alias Sportegic.Users
  alias Sportegic.Users.Role

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "view:role_permissions", :role, permissions) do
      roles = Users.list_roles(org)
      render(conn, "index.html", roles: roles)
    end
  end

  def new(conn, _params, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "create:role_permissions", :role, permissions) do
      changeset = Users.change_role(%Role{})
      permissions = Users.list_permissions_and_category(org)

      render(conn, "new.html",
        changeset: changeset,
        permissions_cats: permissions,
        role_permissions: []
      )
    end
  end

  def create(conn, %{"role" => role_params}, org, permissions) do
    # Set View people true always
    role_params = Map.put(role_params, "5", "true")

    with :ok <- Bodyguard.permit(Users, "create:role_permissions", :role, permissions) do
      {role, permissions} = Map.split(role_params, ["name", "description"])

      permissions =
        permissions
        |> Enum.filter(fn {_k, v} -> v == "true" end)
        |> Map.new()
        |> Map.keys()

      with {:ok, role} <- Users.create_role(role, org),
           {:ok, _role_perissions} <- Users.create_role_permissions(role.id, permissions, org) do
        conn
        |> put_flash(:success, "Your new Role has been successfully created.")
        |> redirect(to: Routes.role_path(conn, :index))
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          IO.inspect(changeset)
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "view:role_permissions", :role, permissions) do
      role = Users.get_role!(id, org)
      render(conn, "show.html", role: role)
    end
  end

  def edit(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "edit:role_permissions", :role, permissions) do
      role = Users.get_role!(id, org)
      changeset = Users.change_role(role)
      permissions = Users.list_permissions_and_category(org)

      case role.id do
        1 ->
          conn
          |> put_flash(:danger, "The Owner Role cannot be edited.")
          |> redirect(to: Routes.role_path(conn, :index))

        _ ->
          IO.inspect(changeset, label: "CHANGESET")
          render(conn, "edit.html",
            role: role,
            changeset: changeset,
            permissions_cats: permissions
          )
      end
    end
  end

  def update(conn, %{"id" => id, "role" => params}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "edit:role_permissions", :role, permissions) do
      role = Users.get_role!(id, org)
      {role_params, permissions} = Map.split(params, ["name", "description"])

      permissions =
        permissions
        |> Enum.filter(fn {_k, v} -> v == "true" end)
        |> Map.new()
        |> Map.keys()
        |> Users.list_permissions(org)

      case Users.update_role(role, role_params, permissions, org) do
        {:ok, _role} ->
          conn
          |> put_flash(:success, "Role updated successfully.")
          |> redirect(to: Routes.role_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          permissions = Users.list_permissions_and_category(org)
          render(conn, "edit.html", role: role, changeset: changeset, permissions: permissions)
      end
    end
  end

  def delete(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "delete:role_permissions", :role, permissions) do
      role = Users.get_role!(id, org)
      {:ok, _role} = Users.delete_role(role, org)

      conn
      |> put_flash(:info, "Role deleted successfully.")
      |> redirect(to: Routes.role_path(conn, :index))
    end
  end
end
