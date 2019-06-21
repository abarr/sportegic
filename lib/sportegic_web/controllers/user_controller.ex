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
          conn
          |> put_flash(:succss, "Invitation seccessuly sent")
          |> redirect(to: Routes.user_path(conn, :index))
        end
    end
  end

  def create(conn, %{"user" => user_params}, org, _permissions) do
    user_params =
      user_params
      |> Map.put("user_id", Integer.to_string(conn.assigns.current_user.id))

    case Users.create_user(user_params, org) do
      {:ok, user} ->
        case user.id do
          1 ->
            user
            |> Users.update_user(%{role_id: "1"}, org)

            conn
            |> redirect(to: Routes.dashboard_path(conn, :index))

          _ ->
            conn
            |> redirect(to: Routes.dashboard_path(conn, :index))
        end

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
           %{ errors: [{ field, { message, _ }}]} = changeset
          case field do
            :role_id -> 
              roles = Users.list_roles(org)
              conn
              |> put_flash(:danger, message)
              |> render("edit.html", user: user, changeset: changeset, roles: roles)
              _    ->
              roles = Users.list_roles(org)
              conn
              |> render("edit.html", user: user, changeset: changeset, roles: roles)
          end
          
      end
    end
  end

  def disable(conn, %{"id" => id}, org, permissions) do
    case Users.is_only_account_owner?(id, org) do
      true ->
        conn
        |> put_flash(
          :danger,
          "This User is the only Account Owner, there must always be at least one Account Owner"
        )
        |> redirect(to: Routes.user_path(conn, :index))

      _ ->
        with :ok <- Bodyguard.permit(Users, "delete:user_permissions", :user, permissions),
             {:ok, user} <- Users.get_user(id, org),
             {:ok, _updated_user} <- Users.update_user(user, %{disabled: true}, org),
             {:ok, organisation} <- Accounts.get_organisation_by_prefix(org),
             {:ok, orgs_user} <- Accounts.get_organisations_users(user.id, organisation.id),
             {:ok, _org_user} <- Accounts.delete_organisations_users(orgs_user) do
          
          conn
          |> put_flash(:danger, "User access successfully disabled")
          |> redirect( to: Routes.user_path(conn, :index))
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
      conn
      |> put_flash(:success, "User access restored succesfully!")
      |> redirect( to: Routes.user_path(conn, :index))
    end
  end

  def resend_invitation(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Users, "create:user_permissions", :user, permissions) do
      # Get the invitation and update it to expired = false
      with {:ok, invitation} <-  Users.update_invitation(Users.get_invitation!(id, org), %{ expired: false }, org),
            {:ok, _id} <- Communication.email_with_token(conn, invitation, invitation.email, "rsvp") do
        
              conn
              |> put_flash(:success, "Invitation successfully sent again, the User has 24 hours")
              |> redirect(to: Routes.user_path(conn, :index))
      else
        _ ->
          conn
          |> put_flash(:danger, "Something is wrong, we could not send invitation!")
          |> redirect(to: Routes.user_path(conn, :index))
      end
    end
  end

  def delete_invitation(conn, %{"id" => id}, org, _permissions) do
    invitation = Users.get_invitation!(id, org)
    {:ok, _invite} = Users.delete_invitation(invitation, org)

    conn
    |> put_flash(:danger, "Invitation deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
