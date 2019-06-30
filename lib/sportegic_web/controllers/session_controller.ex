defmodule SportegicWeb.SessionController do
  use SportegicWeb, :controller

  alias Sportegic.Accounts

  plug :put_layout, "accounts.html"

  def new(conn, _params) do
    conn
    |> render("new.html")
  end

  def create(conn, %{"session" => params}) do
    case Accounts.get_user_by_email(params["email"]) do
      {:ok, nil} ->
        conn
        |> put_flash(:danger, "Either your email or password is incorrect.")
        |> render("new.html")
      
      {:ok, %{verified: false}} ->
        conn
        |> put_flash(
          :danger,
          "Your email has not been verified. If you no longer have the email, or it has expired please use link below"
        )
        |> render("new.html")
  
      {:ok, user} ->
        case Accounts.authenticate_session(user, params["password"]) do
          {:ok, user} ->
            user = %{user | password_hash: "REMOVED"}

            conn
            |> assign(:current_user, user)
            |> put_session(:user_id, user.id)
            |> configure_session(renew: true)
            |> redirect(to: Routes.organisation_path(conn, :index))

          {:error, _error_msg} ->
            conn
            |> put_flash(:danger, "Either your email or password is incorrect. Please try again!")
            |> render("new.html")
        end

      {:error, _msg} ->
        conn
        |> put_flash(:danger, "Either your email or password is incorrect.")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "You have logged out successfully!")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
