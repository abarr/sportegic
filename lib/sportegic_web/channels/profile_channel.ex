defmodule SportegicWeb.ProfileChannel do
  use SportegicWeb, :channel

  alias Sportegic.LookupTypes
  alias Sportegic.People


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


    broadcast!(socket, "profile:#{token}", %{payload: payload})
    {:noreply, socket}
  end

  def handle_in("update_positions", params, socket) do
    IO.puts("Update Postions")
    IO.inspect(params, label: "PARAMS")

    People.update_profile_postions(params["id"], params["positions"], params["org"])

    broadcast!(socket, "profile_update:#{params["token"]}", %{payload: "Postions sccessfully updated!"})
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
