defmodule SportegicWeb.OrgUserController do
  use SportegicWeb, :controller

  alias Sportegic.Users
  alias Sportegic.Users.{User}

  plug SportegicWeb.Plugs.Authenticate

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, _org) do
    changeset = Users.change_user(%User{})

    render(conn, "new.html",
      changeset: changeset,
      layout: {SportegicWeb.LayoutView, "accounts.html"}
    )
  end

  def create(conn, %{"user" => user_params}, org) do
    user_params = Map.put(user_params, "user_id", Integer.to_string(conn.assigns.current_user.id))

    case Users.create_user(user_params, org) do
      {:ok, user} ->
        cond do
          user.id == 1 ->
            Users.update_user(user, %{role_id: 1}, org)
        end

        conn
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, org) do
    user = Users.get_user!(id, org)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}, org) do
    user = Users.get_user!(id, org)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}, org) do
    user = Users.get_user!(id, org)

    case Users.update_user(user, user_params, org) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: Routes.org_user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
