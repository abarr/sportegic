defmodule SportegicWeb.ProfileController do
  use SportegicWeb, :controller

  alias Sportegic.Profiles
  alias Sportegic.Profiles.Profile

  plug SportegicWeb.Plugs.Authenticate

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, _org) do
    changeset = Profiles.change_profile(%Profile{})
    render(conn, "new.html", changeset: changeset, layout: {SportegicWeb.LayoutView, "accounts.html"})
  end

  def create(conn, %{"profile" => profile_params}, org) do
    profile_params = Map.put(profile_params, "user_id", Integer.to_string(conn.assigns.current_user.id))
    case Profiles.create_profile(profile_params, org) do
      {:ok, _profile} ->
        conn
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, org) do
    profile = Profiles.get_profile!(id, org)
    render(conn, "show.html", profile: profile)
  end

  def edit(conn, %{"id" => id}, org) do
    profile = Profiles.get_profile!(id, org)
    changeset = Profiles.change_profile(profile)
    render(conn, "edit.html", profile: profile, changeset: changeset)
  end

  def update(conn, %{"id" => id, "profile" => profile_params}, org) do
    profile = Profiles.get_profile!(id, org)

    case Profiles.update_profile(profile, profile_params, org) do
      {:ok, profile} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: Routes.profile_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profile: profile, changeset: changeset)
    end
  end
  
end
