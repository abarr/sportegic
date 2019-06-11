defmodule SportegicWeb.UserSearchChannel do
  use SportegicWeb, :channel
  alias Sportegic.Users

  def join("user_search:", %{"token" => token}, socket) do
    if authorized?(token, socket.assigns.account_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("search", %{"token" => token, "org" => org}, socket) do
    users = Users.list_users(org)
    # [%{firstname: "", lastname: "", id: 1}, %{...}]
    payload =
      users
      |> Enum.map(fn x ->
        %{(x.firstname <> " " <> x.lastname) => nil}
      end)
      |> Enum.reduce(&Map.merge/2)
      
    broadcast!(socket, "users:#{token}", %{payload: payload})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(token, id) do
    case Phoenix.Token.verify(SportegicWeb.Endpoint, "replace_with_key", token, max_age: 86400) do
      {:ok, account_id} ->
        case account_id === id do
          true -> true
          _ -> false
        end

      _ ->
        false
    end
  end
end
