defmodule Sportegic.Communication.Token do
  alias Sportegic.Accounts.User
  alias Sportegic.Users.Invitation

  @salt "MdFvq0IP3OqOOBULADZ5csdvOizcPJ2z"
  @max_age 86_400
  # @max_age 1

  def generate_token(%User{id: user_id}) do
    Phoenix.Token.sign(SportegicWeb.Endpoint, @salt, user_id)
  end

  def generate_token(%Invitation{id: id, org_name: name}) do
    key = name <> ":" <> Integer.to_string(id)
    Phoenix.Token.sign(SportegicWeb.Endpoint, @salt, key)
  end

  def verify_token(token) do
    case Phoenix.Token.verify(SportegicWeb.Endpoint, @salt, token, max_age: @max_age) do
      {:ok, key} when is_binary(key) -> 
        # Account for invitation tokens containing ref to org (See above)
        case String.contains?(key, ":") do
          true -> {:ok, String.split(key, ":")}
          _    -> {:ok, key}
        end
      {:ok, key}  -> {:ok, key}    
      _          -> {:error, "Invalid Token"}  
    end
  end
end
