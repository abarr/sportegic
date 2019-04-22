defmodule SportegicWeb.DashboardController do
  use SportegicWeb, :controller

  alias Sportegic.Profiles

  plug SportegicWeb.Plugs.Authenticate

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org) do
    # Is there a profile for the user?
    case Profiles.get_profile(conn.assigns.current_user.id, org) do
      {:ok, nil} ->
        conn
        |> redirect(to: Routes.profile_path(conn, :new))

      {:ok, profile} ->
        render(conn, "index.html", profile: profile)

      resp ->
        IO.inspect(resp, label: "Dashboard Index resp")
    end
  end
end
