defmodule SportegicWeb.ProfileChannel do
  use SportegicWeb, :channel

  alias Sportegic.LookupTypes
  alias Sportegic.People
  alias Sportegic.Profiles


  def join("profile:", %{"token" => token}, socket) do
    if authorized?(token, socket.assigns.account_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("get_positions", %{"token" => token, "org" => org, "person_id" => person_id}, socket) do
    person = People.get_person_athlete_profile!(person_id, org)
    player_positions =
      person.athlete_profile.types
      |> Enum.map(fn x ->
        %{"tag" => x.name }
      end)

    lookup = LookupTypes.get_lookup_by_name!("Playing Positions", org)

    all_positions =
      LookupTypes.list_types(lookup, org)
      |> Enum.map(fn x ->
        %{x.name => nil}
      end)
      |> Enum.reduce(&Map.merge/2)


    broadcast!(socket, "profile:#{token}", %{all_positions: all_positions, player_positions: player_positions})
    {:noreply, socket}
  end

  def handle_in("update_positions", %{"org" => org, "person_id" => person_id, "positions" => positions, "token" => token}, socket) do
    lookup = LookupTypes.get_lookup_by_name!("Playing Positions", org)

    positions = positions
    |> Enum.map(fn p ->
       %{ name: p["tag"], lookup_id: lookup.id}
    end)

    case Profiles.update_athlete_profile_postions(person_id, %{ types: positions}, org) do
       {:ok, _profile} ->
        broadcast!(socket, "profile_update:#{token}", %{type: "success", payload: "Positions sccessfully updated!"})
       _ ->
        broadcast!(socket, "profile_update:#{token}", %{type: "success", payload: "There is a problem updating positions. Please call support!"})

    end

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
