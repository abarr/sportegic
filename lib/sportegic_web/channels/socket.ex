defmodule SportegicWeb.Socket do
  use Phoenix.Socket

  alias Sportegic.Users

  ## Channels
  channel "mobile:*", SportegicWeb.MobileChannel
  channel "people_search:*", SportegicWeb.PeopleSearchChannel
  channel "notes:*", SportegicWeb.NotesSearchChannel
  channel "user_search:*", SportegicWeb.UserSearchChannel
  channel "tags:*", SportegicWeb.TagsSearchChannel
  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => "undefined"}, socket, _connect_info) do
    {:ok, socket}
  end

  def connect(%{"token" => token, "org" => org}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "replace_with_key", token, max_age: 1_209_600) do
      {:ok, account_id} ->
        {:ok, user} = Users.get_user(account_id, org)
        roles_permissions = Users.get_roles_permissions(user.role_id, org)

        socket =
          socket
          |> assign(
            :permissions,
            Enum.map(roles_permissions, fn rp ->
              rp.permission.name
              |> String.downcase()
              |> String.replace_suffix("", ":" <> rp.permission.category.key)
            end)
          )
          |> assign(:account_id, account_id)
          |> assign(:organisation, org)

        {:ok, socket}

      {:error, _reason} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     SportegicWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
