defmodule SportegicWeb.PersonView do
  use SportegicWeb, :view

  def error_tag(form, field, class) do
    if error = form.errors[field] do
      content_tag :span, translate_error(error), class: class
    end
  end
end
