defmodule SportegicWeb.InsurancePolicyView do
  use SportegicWeb, :view
  alias Sportegic.People.File

  def display_insurance_policy_link(insurance_policy) do
    {insurance_policy.file, insurance_policy}
    |> File.url()
  end

  def default_coverage_value(form) do
    IO.inspect(form)
    {:ok, default_value} = Money.to_string(Money.new("AUD", "0"), locale: "en")
    default_value
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
end


