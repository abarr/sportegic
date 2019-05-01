defmodule SportegicWeb.LayoutView do
  use SportegicWeb, :view

  alias Sportegic.Users

  def organisation_name(org) do
    case String.contains?(org, "_") do
      true ->
        org
        |> String.split("_")
        |> Enum.map(&String.capitalize/1)
        |> Enum.join(" ")

      _ ->
        String.capitalize(org)
    end
  end

end
