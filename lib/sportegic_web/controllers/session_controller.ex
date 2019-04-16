defmodule SportegicWeb.SessionController do
  use SportegicWeb, :controller

  alias Sportegic.Accounts

  plug :put_layout, "accounts.html"

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => params}) do
    case Accounts.get_user_by_email(params["email"]) do
      {:ok, nil} ->
        conn
        |> put_flash(:danger, "Either your email or password is incorrect. Please try again!")
        |> render("new.html")

      {:ok, user} ->
        case Accounts.authenticate_session(user, params["password"]) do
          {:ok, user} ->
            user = %{user | password_hash: "REMOVED"}

            conn =
              conn
              |> assign(:current_user, user)
              |> put_session(:user_id, user.id)
              |> configure_session(renew: true)
              |> redirect(to: Routes.dashboard_path(conn, :index))

          {:error, _error_msg} ->
            conn
            |> put_flash(:danger, "Either your email or password is incorrect. Please try again!")
            |> render("new.html")
        end
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   session = Accounts.get_session!(id)
  #   {:ok, _session} = Accounts.delete_session(session)

  #   conn
  #   |> put_flash(:info, "Session deleted successfully.")
  #   |> redirect(to: Routes.session_path(conn, :index))
  # end
end
