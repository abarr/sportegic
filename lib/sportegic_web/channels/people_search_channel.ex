defmodule SportegicWeb.PeopleSearchChannel do
  use SportegicWeb, :channel

  alias Sportegic.People

  def join("people_search:", %{"token" => token}, socket) do
    if authorized?(token, socket.assigns.account_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("search", %{"search_value" => value, "token" => token, "org" => org}, socket) do
    # [%{firstname: "", lastname: "", id: 1}, %{...}]
    payload =
      People.list_people(value, org)
      |> Enum.map(fn x ->
        %{(x.firstname <> " " <> x.lastname) => nil}
      end)
      |> Enum.reduce(&Map.merge/2)

    ids =
      People.list_people(value, org)
      |> Enum.map(fn x ->
        %{(x.firstname <> " " <> x.lastname) => "/person/" <> Integer.to_string(x.id)}
      end)
      |> Enum.reduce(&Map.merge/2)

    broadcast!(socket, "search:#{token}", %{payload: payload, ids: ids})
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
