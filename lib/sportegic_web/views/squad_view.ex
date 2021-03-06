defmodule SportegicWeb.SquadView do
  use SportegicWeb, :view

  def error_tag_sportegic(%{errors: errors = [_ | _]}, field) do
    if error = errors[field] do
      {msg, _} = error
      content_tag(:span, "", [{:data, [error: msg]}, class: "helper-text "])
    else
      error_tag_sportegic(field)
    end
  end

  def error_tag_sportegic(_form, field) do
    error_tag_sportegic(field)
  end

  def error_tag_sportegic(field) do
    case field do
      :name ->
        content_tag(:span, "", [
          {:data, [error: "Please name the Squad"]},
          class: "helper-text"
        ])

      :description ->
        content_tag(:span, "", [
          {:data, [error: "Please provide a short description"]},
          class: "helper-text"
        ])

      _ ->
        content_tag(:span, "", [{:data, [error: "This field is invalid"]}, class: "helper-text"])
    end
  end

  def set_field_class(%{errors: errors = [_ | _]}, field) do
    if errors[field] do
      "invalid validate"
    end
  end

  def set_field_class(_form, _field), do: " validate"
end
