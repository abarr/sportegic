defmodule SportegicWeb.UserController do
  use SportegicWeb, :controller

  alias Sportegic.Users
  alias Sportegic.Users.User
  alias Sportegic.Communication

  plug SportegicWeb.Plugs.Authenticate

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org) do
    users = Users.list_users(org)
    invitations = Users.list_invitations(org)
    render(conn, "index.html", users: users, invitations: invitations)
  end

  def new(conn, _params, _org) do
    changeset = Users.change_user(%User{})

    render(conn, "new.html",
      changeset: changeset,
      layout: {SportegicWeb.LayoutView, "accounts.html"}
    )
  end

  def invitation(conn, _params, org) do
    roles =
      Users.list_roles(org)
      |> Enum.map(fn role -> [key: role.name, value: role.id] end)

    roles = [[key: "Choose a Role", value: ""] | roles]
    render(conn, "invitation.html", roles: roles)
  end

  def create_invitation(conn, %{"email" => email, "role" => role_id}, org) do
    with {:ok, invitation} <- Users.create_invitation(%{email: email, role_id: role_id, org_name: org}, org),
         {:ok, _id} <- Communication.email_with_token(conn, invitation, email, "rsvp") do
      users = Users.list_users(org)
      invitations = Users.list_invitations(org)

      conn
      |> put_flash(:succss, "Invitation seccessuly sent")
      |> render("index.html", users: users, invitations: invitations)
    end
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
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
