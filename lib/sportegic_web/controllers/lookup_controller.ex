defmodule SportegicWeb.LookupController do
  use SportegicWeb, :controller

  alias Sportegic.LookupTypes
  
  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, permissions) do
    with :ok <- Bodyguard.permit(LookupTypes, "view:loookup_permissions", "", permissions) do
      lookups = LookupTypes.list_lookups(org)
      render(conn, "index.html", lookups: lookups)
    end
  end

end
