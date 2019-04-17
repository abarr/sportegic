defmodule SportegicWeb.LayoutView do
  use SportegicWeb, :view

  def organisation_name(org) do
    org
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
  
end
