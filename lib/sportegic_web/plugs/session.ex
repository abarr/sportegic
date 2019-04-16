defmodule SportegicWeb.Plugs.Session do
  import Plug.Conn

  alias Sportegic.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    case user_id && Accounts.get_user(user_id) do
      {:ok, nil} ->
        conn
        |> assign(:current_user, nil)

      {:ok, user} ->
        user = %{user | password_hash: "REMOVED"}

        conn
        |> assign(:current_user, user)

      nil ->
        conn
        |> assign(:current_user, nil)
    end
  end
end
