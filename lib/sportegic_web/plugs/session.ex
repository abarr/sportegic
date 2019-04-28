defmodule SportegicWeb.Plugs.Session do
  import Plug.Conn

  alias Sportegic.Accounts
  alias Sportegic.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    case user_id && Accounts.get_user(user_id) do
      {:ok, nil} ->
        conn
        |> assign(:current_user, nil)

      {:ok, account} ->
        account = %{account | password_hash: "REMOVED"}

        case get_session(conn, :organisation) do
          nil ->
            conn
            |> assign(:current_user, account)
            |> assign(:organisation, nil)

          org ->
            case Users.get_user(account.id, org) do
              {:ok, nil} ->
                conn
                |> assign(:current_user, account)
                |> assign(:organisation, org)

              {:ok, user} ->
                conn
                |> assign(:user, user)
                |> assign(:current_user, account)
                |> assign(:organisation, org)
            end
        end

      nil ->
        conn
        |> assign(:current_user, nil)
    end
  end
end
