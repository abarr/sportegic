defmodule SportegicWeb.LayoutView do
  use SportegicWeb, :view
  alias Sportegic.Tasks

  def show_overdue_tasks(conn) do
    case Tasks.count_overdue_tasks(conn.assigns.user.id, conn.assigns.organisation) do
      n when n > 0  -> 
        content_tag(:span, n, [{:data, [ badge: [caption: "Overdue"]]}, class: "new badge red lighten-2"])
      _ -> nil 
    end
  end

  def organisation_name(org) do
    case String.contains?(org, "_") do
      true ->
        org
        |> String.split("_")
        |> Enum.map(&String.capitalize/1)
        |> Enum.join(" ")

      _ ->
        String.capitalize(org)
    end
  end

end
