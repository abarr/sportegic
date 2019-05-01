defmodule Sportegic.Users.Authorisation do
    @behaviour Bodyguard.Policy
  
    # Check the request against the list of permissions for for the current User
    def authorize(request, _note, permissions) do
      case Enum.member?(permissions, request) do
        true -> :ok
        false -> {:error, :unauthorized}
      end
    end
  end