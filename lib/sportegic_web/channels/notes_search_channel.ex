defmodule SportegicWeb.NotesSearchChannel do
  use SportegicWeb, :channel

  alias Sportegic.Notes

  def join("notes:", %{"token" => token}, socket) do
    if authorized?(token, socket.assigns.account_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("recent", %{  "token" => token, "org" => org }, socket) do
    payload = Notes.list_recent_notes(org)
    case Enum.count(payload) do
      0 ->
        broadcast!(socket, "recent:#{token}", %{results: %{}})
        {:noreply, socket}

      _ ->
        broadcast!(socket, "recent:#{token}", %{results: payload})
        {:noreply, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("search", %{"search_value" => value, "token" => token, "org" => org}, socket) do

    # [%{firstname: "", lastname: "", id: 1}, %{...}]
    value = String.trim(value)

    case value do
      "" ->
        {:noreply, socket}

      _ ->
        payload = Notes.list_notes(value, org)

        case Enum.count(payload) do
          0 ->
            broadcast!(socket, "search:#{token}", %{results: %{}})
            {:noreply, socket}

          _ ->
            broadcast!(socket, "search:#{token}", %{results: payload})
            {:noreply, socket}
        end
    end
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
