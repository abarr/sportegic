defmodule SportegicWeb.PerformanceController do
  use SportegicWeb, :controller

  alias Sportegic.Profiles
  alias Sportegic.Profiles.Performance

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end


  def index(conn, _params, person, org, _permissions) do
    performances = Profiles.list_performances(org)
    render(conn, "index.html", performances: performances)
  end

  def new(conn, _params, person, org, _permissions) do
    changeset = Profiles.change_performance(%Performance{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"performance" => performance_params}, person, org, _permissions) do
    case Profiles.create_performance(performance_params, org) do
      {:ok, performance} ->
        conn
        |> put_flash(:info, "Performance created successfully.")
        |> redirect(to: Routes.performance_path(conn, :show, performance))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
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
