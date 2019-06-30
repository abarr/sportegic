defmodule SportegicWeb.PerformanceController do
  use SportegicWeb, :controller

  alias Sportegic.Profiles
  alias Sportegic.People
  alias HtmlSanitizeEx
  alias Sportegic.LookupTypes
  alias Sportegic.Profiles.Performance

  # Allows for getting Types by LookupType
  @areas_ref "Performance Areas"
  @review_ref "Performance Review Type"
  @rating_ref "Performance Rating"


  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, person, org, _permissions) do
    changeset = Profiles.change_performance(%Performance{})

    areas_lookup = LookupTypes.get_lookup_by_name!(@areas_ref, org)
    review_lookup = LookupTypes.get_lookup_by_name!(@review_ref, org)
    rating_lookup = LookupTypes.get_lookup_by_name!(@rating_ref, org)

    area_types = LookupTypes.list_types(areas_lookup, org) |> Enum.map(fn type -> [key: type.name, value: type.id] end)
    review_types = LookupTypes.list_types(review_lookup, org) |> Enum.map(fn type -> [key: type.name, value: type.id] end)
    rating_types = LookupTypes.list_types(rating_lookup, org) |> Enum.map(fn type -> [key: type.name, value: type.id] end)

    area_types = [[key: "Performance Area", value: "", disabled: "true", selected: "true"] | area_types]
    review_types = [[key: "Review Type", value: "", disabled: "true", selected: "true"] | review_types]
    rating_types = [[key: "Rating", value: "", disabled: "true", selected: "true", class: "grey-text lighten-2"] | rating_types]

    

    render(conn, "new.html", 
      changeset: changeset, 
      person: person, 
      athlete_profile: person.athlete_profile,
      area_types: area_types,
      review_types: review_types, 
      rating_types: rating_types
      )
  end

  def create(conn, %{"performance" => performance_params, "profile_id" => profile_id, "person_id" => person_id}, _person, org, _permissions) do
    performance_params = performance_params
    |> only_basic_html()
    |> Map.put("athlete_profile_id", profile_id)
    |> Map.put("user_id", to_string(conn.assigns.user.id))
    
    case Profiles.create_performance(performance_params, org) do
      {:ok, _performance} ->
        person = People.get_person!(person_id, conn.assigns.organisation)
        conn
        |> put_flash(:info, "Performance created successfully.")
        |> redirect(to: Routes.person_profile_path(conn, :index, person))

      {:error, %Ecto.Changeset{} = changeset} ->
        person = People.get_person!(person_id, conn.assigns.organisation)
        render(conn, "new.html", changeset: changeset, person: person, athlete_profile: person.athlete_profile)
    end
  end

  defp only_basic_html(%{"review" => review} = params) do
    params
    |> Map.put("review", HtmlSanitizeEx.basic_html(review))
  end

  def show(conn, %{"id" => id}, person, org, _permissions) do
    performance = Profiles.get_performance!(id, org)
    render(conn, "show.html", performance: performance)
  end

  def edit(conn, %{"id" => id}, person, org, _permissions) do
    performance = Profiles.get_performance!(id, org)
    changeset = Profiles.change_performance(performance)
    render(conn, "edit.html", performance: performance, changeset: changeset)
  end

  def update(conn, %{"id" => id, "performance" => performance_params}, person, org, _permissions) do
    performance = Profiles.get_performance!(id, org)

    case Profiles.update_performance(performance, performance_params, org) do
      {:ok, performance} ->
        conn
        |> put_flash(:info, "Performance updated successfully.")
        |> redirect(to: Routes.performance_path(conn, :show, performance))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", performance: performance, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, person, org, _permissions) do
    performance = Profiles.get_performance!(id, org)
    {:ok, _performance} = Profiles.delete_performance(performance)

    conn
    |> put_flash(:info, "Performance deleted successfully.")
    |> redirect(to: Routes.performance_path(conn, :index))
  end
end
