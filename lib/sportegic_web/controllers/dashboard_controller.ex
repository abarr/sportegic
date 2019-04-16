defmodule SportegicWeb.DashboardController do
  use SportegicWeb, :controller

  plug SportegicWeb.Plugs.Authenticate

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
