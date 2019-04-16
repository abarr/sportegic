defmodule SportegicWeb.UserController do
  use SportegicWeb, :controller

  alias Sportegic.Accounts
  alias Sportegic.Accounts.User
  alias Sportegic.Communication
  alias Sportegic.Communication.Token

  plug :put_layout, "accounts.html"

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params),
         {:ok, _id} <- Communication.generate_verification_email(conn, user) do
      redirect(conn, to: Routes.user_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def verification(conn, %{"token" => token}) do
    with {:ok, user_id} <- Token.verify_token(token),
         {:ok, user} <- Accounts.get_user(user_id),
         {:ok, _user} <- Accounts.update_user(user, %{verified: true}) do
      conn
      |> put_flash(:success, "Your email is verified. Please test your login!")
      |> redirect(to: Routes.session_path(conn, :new))
    else
      {:error, _error} ->
        conn
        |> render("resend_verification.html")
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
