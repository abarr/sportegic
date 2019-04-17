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
        redirect(conn, to: Routes.profile_path(conn, :new))
      {:ok, profile} ->
        render(conn, "index.html", profile: profile)
      resp -> 
        IO.inspect(resp, label: "Dashboard Index resp")  
    end
    # if yes add profile to assigns
    # If no redirect to new profile page (pre-fill email)
    
  end
end
