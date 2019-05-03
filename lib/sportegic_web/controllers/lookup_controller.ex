defmodule SportegicWeb.LookupController do
  use SportegicWeb, :controller

  alias Sportegic.LookupTypes
  alias Sportegic.LookupTypes.Lookup

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, _permissions) do
    lookups = LookupTypes.list_lookups(org)
    render(conn, "index.html", lookups: lookups)
  end

  def new(conn, _params, _org, _permissions) do
    changeset = LookupTypes.change_lookup(%Lookup{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"lookup" => lookup_params}, org, _permissions) do
    case LookupTypes.create_lookup(lookup_params, org) do
      {:ok, lookup} ->
        conn
        |> put_flash(:info, "Lookup created successfully.")
        |> redirect(to: Routes.lookup_path(conn, :show, lookup))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, org, _permissions) do
    lookup = LookupTypes.get_lookup!(id, org)
    render(conn, "show.html", lookup: lookup)
  end

  def edit(conn, %{"id" => id}, org, _permissions) do
    lookup = LookupTypes.get_lookup!(id, org)
    changeset = LookupTypes.change_lookup(lookup)
    render(conn, "edit.html", lookup: lookup, changeset: changeset)
  end

  def update(conn, %{"id" => id, "lookup" => lookup_params}, org, _permissions) do
    lookup = LookupTypes.get_lookup!(id, org)

    case LookupTypes.update_lookup(lookup, lookup_params, org) do
      {:ok, lookup} ->
        conn
        |> put_flash(:info, "Lookup updated successfully.")
        |> redirect(to: Routes.lookup_path(conn, :show, lookup))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", lookup: lookup, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, org, _permissions) do
    lookup = LookupTypes.get_lookup!(id, org)
    {:ok, _lookup} = LookupTypes.delete_lookup(lookup, org)

    conn
    |> put_flash(:info, "Lookup deleted successfully.")
    |> redirect(to: Routes.lookup_path(conn, :index))
  end
end
