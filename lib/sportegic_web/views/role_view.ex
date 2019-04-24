defmodule SportegicWeb.RoleView do
  use SportegicWeb, :view

  def field_name_as_atom(name) do
    name
    |> String.trim
    |> String.replace(" ", "_")
    |> String.downcase
    |> String.to_atom
  end

  def field_name_as_string(name) do
    name
    |> String.trim
    |> String.replace(" ", "_")
    |> String.downcase
  end
end
