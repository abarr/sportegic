defmodule SportegicWeb.RoleView do
  use SportegicWeb, :view

  def field_name_as_atom(name) do
    name
    |> String.trim()
    |> String.replace(" ", "_")
    |> String.downcase()
    |> String.to_atom()
  end

  def field_name_as_string(name) do
    name
    |> String.trim()
    |> String.replace(" ", "_")
    |> String.downcase()
  end

  def get_permission_state(id, role) do
    case role do
      nil ->
        "false"

      _ ->
        case Enum.find(role.permissions, fn p -> p.id == id end) do
          nil -> "false"
          _ -> "true"
        end
    end
  end

  def disable_if_owner(role_id) do
    case role_id do
      1 -> 'disabled: "true"'
      _ -> nil
    end
  end
end
