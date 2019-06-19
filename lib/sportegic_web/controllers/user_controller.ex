defmodule SportegicWeb.UserController do
  use SportegicWeb, :controller

  alias Sportegic.Users
  alias Sportegic.Users.User
  alias Sportegic.Accounts
  alias Sportegic.Communication

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "view:user_permissions", :user, permissions) do
      users = Users.list_users(org)
      invitations = Users.list_invitations(org)
      render(conn, "index.html", users: users, invitations: invitations)
    end
  end

  def new(conn, _params, _org, _permissions) do
    changeset = Users.change_user(%User{})

    render(conn, "new.html",
      changeset: changeset,
      layout: {SportegicWeb.LayoutView, "accounts.html"}
    )
  end

  def invitation(conn, _params, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "create:user_permissions", :user, permissions) do
      roles =
        Users.list_roles(org)
        |> Enum.map(fn role -> [key: role.name, value: role.id] end)

      roles = [[key: "Choose a Role", value: ""] | roles]
      render(conn, "invitation.html", roles: roles)
    end
  end

  def create_invitation(conn, %{"email" => email, "role" => role_id}, org, permissions) do
    case Accounts.get_user_status(email, org) do
      {:exists_disabled} ->
        roles =
          Users.list_roles(org)
          |> Enum.map(fn role -> [key: role.name, value: role.id] end)

        conn
        |> put_flash(
          :danger,
          "This User is already registered to your organisation but has been disabled!"
        )
        |> render("invitation.html", roles: roles)

      {:exists} ->
        roles =
          Users.list_roles(org)
          |> Enum.map(fn role -> [key: role.name, value: role.id] end)

        conn
        |> put_flash(:info, "This User is already registered to your organisation!")
        |> render("invitation.html", roles: roles)

      {:new} ->
        with :ok <- Bodyguard.permit(Users, "create:user_permissions", :user, permissions),
             {:ok, invitation} <-
               Users.create_invitation(%{email: email, role_id: role_id, org_name: org}, org),
             {:ok, _id} <- Communication.email_with_token(conn, invitation, email, "rsvp") do
          users = Users.list_users(org)
          invitations = Users.list_invitations(org)

          conn
          |> put_flash(:succss, "Invitation seccessuly sent")
          |> render("index.html", users: users, invitations: invitations)
        end
    end
  end

  def create(conn, %{"user" => user_params} = params, org, _permissions) do
    IO.inspect(params)
    
    user_params = user_params
    |> Map.put("user_id", Integer.to_string(conn.assigns.current_user.id))
    |> IO.inspect

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

  def show(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "view:user_permissions", :user, permissions) do
      user = Users.get_user!(id, org)
      render(conn, "show.html", user: user)
    end
  end

  def edit(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "edit:user_permissions", :user, permissions) do
      user = Users.get_user!(id, org)
      roles = Users.list_roles(org)
      changeset = Users.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "edit:user_permissions", :user, permissions) do
      user = Users.get_user!(id, org)

      case Users.update_user(user, user_params, org) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "Profile updated successfully.")
          |> redirect(to: Routes.user_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          IO.inspect(changeset)
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    end
  end

  def disable(conn, %{"id" => id}, org, permissions) do
    case Users.count_account_owners(org) do
      1 ->
        users = Users.list_users(org)
        invitations = Users.list_invitations(org)

        conn
        |> put_flash(
          :danger,
          "This User is the only Account Owner, there must always be at least one Account Owner"
        )
        |> render("index.html", users: users, invitations: invitations)

      _ ->
        with :ok <- Bodyguard.permit(Users, "delete:user_permissions", :user, permissions),
             {:ok, user} <- Users.get_user(id, org),
             {:ok, _updated_user} <- Users.update_user(user, %{disabled: true}, org),
             {:ok, organisation} <- Accounts.get_organisation_by_prefix(org),
             {:ok, orgs_user} <- Accounts.get_organisations_users(user.id, organisation.id),
             {:ok, _org_user} <- Accounts.delete_organisations_users(orgs_user) do
          users = Users.list_users(org)
          invitations = Users.list_invitations(org)

          conn
          |> put_flash(:success, "User access successfully disbaled")
          |> render("index.html", users: users, invitations: invitations)
        end
    end
  end

  def enable(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "create:user_permissions", :user, permissions),
         {:ok, user} <- Users.get_user(id, org),
         {:ok, updated_user} <- Users.update_user(user, %{disabled: false}, org),
         {:ok, organisation} <- Accounts.get_organisation_by_prefix(org),
         {:ok, _orgs_users} <-
           Accounts.create_organisations_users(%{
             user_id: updated_user.id,
             organisation_id: organisation.id
           }) do
      users = Users.list_users(org)
      invitations = Users.list_invitations(org)
      render(conn, "index.html", users: users, invitations: invitations)
    end
  end
end
