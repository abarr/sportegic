defmodule Sportegic.Users.UserMobileType do
  @behaviour Ecto.Type
  def type, do: :string

  def cast(mobile) when is_binary(mobile) do
    mobile =
      mobile
      |> String.trim()
      |> String.replace(" ", "")
    {:ok, mobile}
  end

  def cast(_), do: :error

  def load(data) when is_binary(data) do
    {:ok, data}
  end

  def dump(mobile) when is_binary(mobile), do: {:ok, mobile}
  def dump(_), do: :error
end
