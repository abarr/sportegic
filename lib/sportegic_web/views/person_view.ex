defmodule SportegicWeb.PersonView do
  use SportegicWeb, :view

  alias Sportegic.People.Avatar

  def display_image(person) do
    {person.profile_image, person}
    |> Avatar.url()
    |> img_tag()
  end

  def error_tag(form, field, class) do
    if error = form.errors[field] do
      content_tag(:span, translate_error(error), class: class)
    end
  end
end
