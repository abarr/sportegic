defmodule SportegicWeb.PageController do
  use SportegicWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
