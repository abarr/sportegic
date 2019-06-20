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

  def error_tag_sportegic(%{errors: errors = [_ | _]}, field) do
    
    if error = errors[field] do
      {msg, _} = error
      content_tag(:span, "", [{:data, [error: msg]}, class: " helper-text"])
    else
      error_tag_sportegic(field)
    end
  end

  def error_tag_sportegic(_form, field) do
    error_tag_sportegic(field)
  end

  def error_tag_sportegic(field) do
    case field do
      :description ->
        content_tag(:span, "", [
          {:data, [error: "Please provide a short description"]},
          class: "helper-text"
        ])
      :role_id ->
        content_tag(:span, "", [
          {:data, [error: "Please provide a short description"]},
          class: "helper-text"
        ])  

      _ ->
        content_tag(:span, "", [{:data, [error: "This field is invalid"]}, class: "helper-text"])
    end
  end

end
