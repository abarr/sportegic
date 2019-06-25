defmodule SportegicWeb.ProfileChannel do
  use SportegicWeb, :channel

  alias Sportegic.LookupTypes

  def join("profile:", %{"token" => token}, socket) do
    if authorized?(token, socket.assigns.account_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("get_positions", %{"token" => token, "org" => org}, socket) do
    lookup = LookupTypes.get_lookup_by_name!("Playing Positions", org)
    # [%{firstname: "", lastname: "", id: 1}, %{...}]
    payload =
      LookupTypes.list_types(lookup, org)
      |> Enum.map(fn x ->
        %{x.name => nil}
      end)
      |> Enum.reduce(&Map.merge/2)

    ids =
      LookupTypes.list_types(lookup, org)
      |> Enum.map(fn x ->
        %{x.name => Integer.to_string(x.id)}
      end)
      |> Enum.reduce(&Map.merge/2)

    broadcast!(socket, "profile:#{token}", %{payload: payload, ids: ids})
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
