defmodule SportegicWeb.DashboardController do
  use SportegicWeb, :controller

  alias Sportegic.Users

  plug SportegicWeb.Plugs.Authenticate

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org) do
    case Users.get_user(conn.assigns.current_user.id, org) do
      {:ok, nil} ->
        conn
        |> redirect(to: Routes.user_path(conn, :new))
   
      {:ok, user} ->
        render(conn, "index.html", user: user)
    end
  end

end
