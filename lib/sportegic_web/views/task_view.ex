defmodule SportegicWeb.TaskView do
  use SportegicWeb, :view

  alias Sportegic.People.Avatar
  alias HtmlSanitizeEx

  def display_image(person) do
    {person.profile_image, person}
    |> Avatar.url(:thumb)
    |> img_tag()
  end

  def display_action(action) do
    Jason.decode(action)
  end

  def time_until_date(days, date, timezone) do
    case days do
      n when is_integer(n) and n == 0 ->
        "<blockquote class='page task-danger'><h6 class='red-text'>This task is due today.</h6></blockquote>"

      n when is_integer(n) and n < 0 ->
        abs_days = days |> abs() |> Integer.to_string()

        case abs_days do
          "1" ->
            "<blockquote class='page task-danger'><h6 class='red-text'>This task is overdue by " <>
              abs_days <> " day. Due date was " <> readable_date!(date, timezone) <> "</h6></blockquote>"

          _ ->
            "<blockquote class='page task-danger'><h6 class='red-text'>This task is overdue by " <>
              abs_days <> " days. Due date was " <> readable_date!(date, timezone) <> "</h6></blockquote>"
        end

      n when is_integer(n) and n > 0 ->
        case n do
          1 ->
            "<blockquote class='page task-success'><h6>This task is due in " <>
              Integer.to_string(days) <>
              " day. Due Date was " <> readable_date!(date, timezone) <> "</h6></blockquote>"

          _ ->
            "<blockquote class='page task-success'><h6>This task is due in " <>
              Integer.to_string(days) <>
              " days. Due Date was " <> readable_date!(date, timezone) <> "</h6></blockquote>"
        end
    end
  end

  def display_days(days_until) do
    case days_until do
      n when is_integer(n) and n == 0 ->
        "<div class=\"\">
              <span class=\"red-text lighten-2\">Due today!</span>
            </div>"

      n when is_integer(n) and n < 0 ->
        days = Integer.to_string(abs(n))
        n = abs(n)

        case n do
          1 ->
            "<div class=\"\">
              <span class=\"red-text lighten-2\">Overdue #{days} day</span>
            </div>"

          _ ->
            "<div class=\"\">
              <span class=\"red-text lighten-2\">Overdue #{days} days</span>
            </div>"
        end

      n when is_integer(n) and n > 0 ->
        days = Integer.to_string(n)
        n = abs(n)

        case n do
          1 ->
            "<div class=\"\">
              <span class=\"grey-text lighten-2\">Due in #{days} day</span>
            </div>"

          _ ->
            "<div class=\"\">
              <span class=\"grey-text lighten-2\">Due in #{days} days</span>
            </div>"
        end
    end
  end

  def display_status(complete) do
    case complete do
      true ->
        "<span class='new badge green  lighten-2' data-badge-caption='COMPLETED'></span>"

      _ ->
        "<span class='new badge red  lighten-2' data-badge-caption='PENDING'></span>"
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
      :expiry_date ->
        content_tag(:span, "", [
          {:data, [error: "Please provide an expiry date"]},
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
