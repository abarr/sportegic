defmodule SportegicWeb.FallbackController do
  use SportegicWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_flash(:danger, "You are not authorised to enter this section of the site!")
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end

  def call(conn, _response) do
    conn
    |> put_flash(:danger, "DISASTER!")
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end
end
