defmodule SportegicWeb.PersonView do
  use SportegicWeb, :view

  alias Sportegic.People.Avatar

  def display_image(person) do
    {person.profile_image, person}
    |> Avatar.url()
    |> img_tag()
  end

  def error_tag_sportegic(%{errors: errors = [_ | _]}, field) do
    if error = errors[field] do
      {msg, _} = error
      content_tag(:span, "", [{:data, [error: msg]}, class: "helper-text"])
    else
      error_tag_sportegic(field)
    end
  end

  def error_tag_sportegic(_form, field) do
    error_tag_sportegic(field)
  end

  def error_tag_sportegic(field) do
    case field do
      :firstname ->
        content_tag(:span, "", [
          {:data, [error: "Please enter your first name"]},
          class: "helper-text"
        ])

      :lastname ->
        content_tag(:span, "", [
          {:data, [error: "Please enter your last name"]},
          class: "helper-text"
        ])

      :mobile ->
        content_tag(:span, "", [
          {:data, [error: "Include country code e.g. +61"]},
          class: "helper-text"
        ])

      :email ->
        content_tag(:span, "", [
          {:data, [error: "Please enter a valid email"]},
          class: "helper-text"
        ])

      :dob ->
        content_tag(:span, "", [
          {:data, [error: "Please provide your date of birth"]},
          class: "helper-text"
        ])

      _ ->
        content_tag(:span, "", [{:data, [error: "This field is invalid"]}, class: "helper-text"])
    end
  end

  def set_field_class(%{errors: errors = [_ | _]}, field, classes) do
    if errors[field] do
      "invalid validate " <> classes
    end
  end

  def set_field_class(_form, _field, classes), do: " validate " <> classes
end
