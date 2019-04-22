defmodule SportegicWeb.Plugs.Authenticate do
  import Plug.Conn

  alias SportegicWeb.Router.Helpers
  use Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> redirect(to: Helpers.session_path(conn, :new))
      |> halt()
    end
  end
end
