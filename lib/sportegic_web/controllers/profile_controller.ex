defmodule SportegicWeb.ProfileController do
  use SportegicWeb, :controller

  alias Sportegic.People
  alias Sportegic.Profiles


  # Allows for getting Types by LookupType
  # @type_ref "Playing Positions"

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, person, org, _permissions) do
    profiles = Profiles.list_athlete_profiles(person, org)
    render(conn, "index.html", profiles: profiles, person: person)
  end

end
