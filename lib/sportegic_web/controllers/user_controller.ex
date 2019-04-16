defmodule SportegicWeb.UserController do
  use SportegicWeb, :controller

  alias Sportegic.Accounts
  alias Sportegic.Accounts.User
  alias Sportegic.Communication
  alias Sportegic.Communication.Token

  plug :put_layout, "accounts.html"

  action_fallback SportegicWeb.FallbackController

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params),
         {:ok, _id} <- Communication.generate_email(conn, user, "verification") do
      redirect(conn, to: Routes.user_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def request_reset(conn, _params) do
    render(conn, "request_reset.html")
  end

  def send_reset(conn, %{"email" => email} = params) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
         {:ok, _id} <- Communication.generate_email(conn, user, "new_password") do
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

  def send_verification(conn, %{"email" => email} = params) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
         {:ok, _id} <- Communication.generate_email(conn, user, "verification") do
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
        case String.contains?(ref, "/user") do
          true -> render(conn, "confirmation.html")
          _ -> render(conn, "index.html")
        end

      _ ->
        render(conn, "index.html")
    end
  end
end
