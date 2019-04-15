defmodule Sportegic.Accounts.OrganisationPrefix do
  @behaviour Ecto.Type
  def type, do: :string

  def cast(prefix) when is_binary(prefix) do
    prefix =
      prefix
      |> String.replace(' ', '_')
      |> String.downcase()

    {:ok, prefix}
  end

  def cast(_), do: :error

  def load(data) when is_binary(data) do
    {:ok, data}
  end

  def dump(prefix) when is_binary(prefix), do: {:ok, prefix}
  def dump(_), do: :error
end
