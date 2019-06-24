defmodule SportegicWeb.AthleticProfileController do
  use SportegicWeb, :controller

  alias Sportegic.People


  # Allows for getting Types by LookupType
  # @type_ref "Playing Positions"

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, person, org, _permissions) do
    athletic_profiles = People.list_athletic_profiles(person, org)
    render(conn, "index.html", athletic_profiles: athletic_profiles, person: person)
  end

  # def new(conn, _params) do
  #   changeset = People.change_athletic_profile(%AthleticProfile{})
  #   render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"athletic_profile" => athletic_profile_params}) do
  #   case People.create_athletic_profile(athletic_profile_params) do
  #     {:ok, athletic_profile} ->
  #       conn
  #       |> put_flash(:info, "Athletic profile created successfully.")
  #       |> redirect(to: Routes.athletic_profile_path(conn, :show, athletic_profile))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   athletic_profile = People.get_athletic_profile!(id)
  #   render(conn, "show.html", athletic_profile: athletic_profile)
  # end

  # def edit(conn, %{"id" => id}) do
  #   athletic_profile = People.get_athletic_profile!(id)
  #   changeset = People.change_athletic_profile(athletic_profile)
  #   render(conn, "edit.html", athletic_profile: athletic_profile, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "athletic_profile" => athletic_profile_params}) do
  #   athletic_profile = People.get_athletic_profile!(id)

  #   case People.update_athletic_profile(athletic_profile, athletic_profile_params) do
  #     {:ok, athletic_profile} ->
  #       conn
  #       |> put_flash(:info, "Athletic profile updated successfully.")
  #       |> redirect(to: Routes.athletic_profile_path(conn, :show, athletic_profile))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", athletic_profile: athletic_profile, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   athletic_profile = People.get_athletic_profile!(id)
  #   {:ok, _athletic_profile} = People.delete_athletic_profile(athletic_profile)

  #   conn
  #   |> put_flash(:info, "Athletic profile deleted successfully.")
  #   |> redirect(to: Routes.athletic_profile_path(conn, :index))
  # end
end
