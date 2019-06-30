defmodule SportegicWeb.TypeController do
  use SportegicWeb, :controller

  alias Sportegic.LookupTypes
  alias Sportegic.LookupTypes.Type

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    lookup = LookupTypes.get_lookup!(conn.params["lookup_id"], conn.assigns.organisation)
    args = [conn, conn.params, lookup, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, lookup, org, permissions) do
    with :ok <- Bodyguard.permit(LookupTypes, "view:lookup_permissions", "", permissions) do
      types = LookupTypes.list_types(lookup, org)
      render(conn, "index.html", types: types, lookup: lookup)
    end
  end

  def new(conn, _params, lookup, _org, permissions) do
    with :ok <- Bodyguard.permit(LookupTypes, "create:lookup_permissions", "", permissions) do
        changeset =
        %Type{lookup_id: lookup.id}
        |> LookupTypes.change_type()

      render(conn, "new.html", changeset: changeset, lookup: lookup)
    end
  end

  def create(conn, %{"type" => type_params}, lookup, org, permissions) do
    with :ok <- Bodyguard.permit(LookupTypes, "create:lookup_permissions", "", permissions) do
      type_params =
        type_params
        |> Map.put("lookup_id", lookup.id)

      case LookupTypes.create_type(type_params, org) do
        {:ok, _type} ->
          conn
          |> put_flash(:info, "Type created successfully.")
          |> redirect(to: Routes.lookup_type_path(conn, :index, lookup))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset, lookup: lookup)
      end
    end
  end

  def edit(conn, %{"id" => id}, lookup, org, permissions) do
    with :ok <- Bodyguard.permit(LookupTypes, "edit:lookup_permissions", "", permissions) do
      type = LookupTypes.get_type!(lookup, id, org)
      changeset = LookupTypes.change_type(type)
      render(conn, "edit.html", type: type, changeset: changeset, lookup: lookup)
    end
  end

  def update(conn, %{"id" => id, "type" => type_params}, lookup, org, permissions) do
    with :ok <- Bodyguard.permit(LookupTypes, "edit:lookup_permissions", "", permissions) do
      type = LookupTypes.get_type!(lookup, id, org)

      case LookupTypes.update_type(type, type_params, org) do
        {:ok, _type} ->
          conn
          |> put_flash(:info, "Type updated successfully.")
          |> redirect(to: Routes.lookup_type_path(conn, :index, lookup))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", type: type, changeset: changeset, lookup: lookup)
      end
    end
  end

end
