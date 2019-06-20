defmodule Sportegic.Accounts.UserEmailType do
  @behaviour Ecto.Type
  def type, do: :string

  def cast(email) when is_binary(email) do
    email =
      email
      |> String.trim()
      |> String.downcase()

    {:ok, email}
  end

  def cast(_), do: :error

  def load(data) when is_binary(data) do
    {:ok, data}
  end

  def dump(email) when is_binary(email), do: {:ok, email}
  def dump(_), do: :error
end
