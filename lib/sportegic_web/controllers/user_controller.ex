defmodule SportegicWeb.UserController do
  use SportegicWeb, :controller

  alias Sportegic.Accounts
  alias Sportegic.Accounts.User

  plug :put_layout, "accounts.html"

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _params) do
     case List.keyfind(conn.req_headers, "referer", 0) do
      {"referer", ref} ->
        case String.contains?(ref, "/user") do
          true -> render(conn, "confirmation.html")
          _    -> render(conn, "index.html")
        end
      _                ->
        render(conn, "index.html")
     end
  end

end
