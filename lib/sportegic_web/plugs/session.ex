defmodule SportegicWeb.Plugs.Session do
  import Plug.Conn

  alias Sportegic.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    org = get_session(conn, :organisation)
    IO.inspect(org, label: "This is org from session:------------------>")

    case user_id && Accounts.get_user(user_id) do
      {:ok, nil} ->
        conn
        |> assign(:current_user, nil)

      {:ok, user} ->
        user = %{user | password_hash: "REMOVED"}

        conn
        |> assign(:current_user, user)
        |> assign(:organisation, org)

      nil ->
        conn
        |> assign(:current_user, nil)
    end
  end
end
