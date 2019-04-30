defmodule SportegicWeb.AccountController do
  use SportegicWeb, :controller

  alias Sportegic.Accounts
  alias Sportegic.Accounts.{User, Rsvp}
  alias Sportegic.Users
  alias Sportegic.Communication
  alias Sportegic.Communication.Token

  plug :put_layout, "accounts.html"

  action_fallback SportegicWeb.FallbackController

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def rsvp(conn, %{"token" => token}) do
    with {:ok, key} <- Token.verify_token(token) do
      [org, invite_id] = key |> String.split(":")
      invitation = Users.get_invitation!(invite_id, org)
      resp = Users.update_invitation(invitation, %{completed: true}, org)

      changeset =
        %Rsvp{}
        |> Accounts.change_rsvp()
        |> Ecto.Changeset.put_change(:email, invitation.email)
        |> Ecto.Changeset.put_change(:role_id, invitation.role_id)
        |> Ecto.Changeset.put_change(:org, readify(invitation.org_name))

      conn
      |> render("rsvp.html", changeset: changeset, invitation: invitation)
    end
  end

  def create_from_rsvp(conn, %{"rsvp" => rsvp}) do
    {_old, rsvp} = Map.get_and_update(rsvp, "org", fn v -> {v, prefixify(v)} end)
    rsvp = Map.put(rsvp, "verified", "true")
    {:ok, org} = Accounts.get_organisation_by_prefix(rsvp["org"])
    role = Users.get_role_by_name(rsvp["role_id"], org.prefix)
    {user_params, _params} = Map.split(rsvp, ["firstname", "lastname", "mobile"])

    with {:ok, account} <- Accounts.create_user(rsvp),
         {:ok, _realtionship} <-
           Accounts.create_organisations_users(%{user_id: account.id, organisation_id: org.id}) do
      user_params =
        user_params
        |> Map.put("role_id", Integer.to_string(role.id))
        |> Map.put("user_id", Integer.to_string(account.id))

      case Users.create_user(user_params, org.prefix) do
        {:ok, _user} ->
          conn
          |> put_flash(:success, "Your account has been created. Time to test your login!")
          |> redirect(to: Routes.session_path(conn, :new))

        {:error, changeset} ->
          IO.inspect(changeset)

          render(conn, "rsvp.html", changeset: changeset)
      end
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params),
         {:ok, _id} <- Communication.email_with_token(conn, user, user.email, "verification") do
      redirect(conn, to: Routes.account_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def request_reset(conn, _params) do
    render(conn, "request_reset.html")
  end

  def send_reset(conn, %{"email" => email}) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
         {:ok, _id} <- Communication.email_with_token(conn, user, user.email, "new_password") do
      render(conn, "confirmation.html")
    end
  end

  def new_password(conn, %{"token" => token}) do
    with {:ok, user_id} <- Token.verify_token(token),
         {:ok, user} <- Accounts.get_user(user_id) do
      user = %{user | password_hash: "REMOVED"}
      render(conn, "new_password.html", user: user)
    end
  end

  def update_password(conn, %{"password" => password, "user_id" => user_id}) do
    with {:ok, user} <- Accounts.get_user(user_id),
         {:ok, _user} <- Accounts.update_user(user, %{password: password}) do
      conn
      |> put_flash(:success, "Your account has been updated. Please test your login!")
      |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def request_verification(conn, _params) do
    render(conn, "request_verification.html")
  end

  def send_verification(conn, %{"email" => email}) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
         {:ok, _id} <- Communication.email_with_token(conn, user, user.email, "verification") do
      render(conn, "confirmation.html")
    end
  end

  def verification(conn, %{"token" => token}) do
    with {:ok, user_id} <- Token.verify_token(token),
         {:ok, user} <- Accounts.get_user(user_id),
         {:ok, _user} <- Accounts.update_user(user, %{verified: true}) do
      conn
      |> put_flash(:success, "Your email is verified. Please test your login!")
      |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def index(conn, _params) do
    case List.keyfind(conn.req_headers, "referer", 0) do
      {"referer", ref} ->
        case String.contains?(ref, "/account") do
          true -> render(conn, "confirmation.html")
          _ -> render(conn, "index.html")
        end

      _ ->
        render(conn, "index.html")
    end
  end

  defp readify(org) do
    org
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp prefixify(org) do
    org
    |> String.split(" ")
    |> Enum.map(&String.downcase/1)
    |> Enum.join(" ")
    |> String.replace(" ", "_")
  end
end
