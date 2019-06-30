defmodule SportegicWeb.PerformanceView do
  use SportegicWeb, :view

  alias HtmlSanitizeEx

  
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
      :performance_date ->
        content_tag(:span, "", [
          {:data, [error: "Please provide a date"]},
          class: "helper-text"
        ])
      :context_id ->
        content_tag(:span, "", [
          {:data, [error: "Must select review type"]},
          class: "helper-text"
        ])  
      :performance_area_id ->
      content_tag(:span, "", [
        {:data, [error: "Identify the performance area"]},
        class: "helper-text"
      ])
      :rating_id ->
      content_tag(:span, "", [
        {:data, [error: "Provide a rating"]},
        class: "helper-text"
      ])

      _ ->
        content_tag(:span, "", [{:data, [error: "This field is invalid"]}, class: "helper-text"])
    end
  end

  def set_field_class(%{errors: errors = [_ | _]}, field, classes) do
    if errors[field] do
      "invalid " <> classes
    end
  end

  def set_field_class(_form, _field, classes), do: classes

  def sanitize_html_to_text(text) do
    text
    |> String.replace(~r/<li>/, "\\g{1}- ", global: true)
    |> String.replace(
      ~r/<\/?\s?br>|<\/\s?p>|<\/\s?li>|<\/\s?div>|<\/\s?h.>/,
      "\\g{1}\n\r",
      global: true
    )
    |> HtmlSanitizeEx.strip_tags()
  end
end
