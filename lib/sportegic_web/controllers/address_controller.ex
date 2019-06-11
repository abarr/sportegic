defmodule SportegicWeb.AddressController do
  use SportegicWeb, :controller

  alias Sportegic.Addresses
  alias Sportegic.Addresses.Address
  alias Sportegic.LookupTypes
  alias Sportegic.People

  # Allows for getting Types by LookupType
  @type_ref "Address Types"

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"],
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end


  def index(conn, params, person, org, _permissions) do
    addresses = Addresses.list_addresses(org)
    render(conn, "index.html", addresses: addresses, person: person)
  end

  def new(conn, params, person, org, _permissions) do
        changeset = Addresses.change_address(%Address{})
        lookup = LookupTypes.get_lookup_by_name!(@type_ref, org)

        types =
          LookupTypes.list_types(lookup, org)
          |> Enum.map(fn type -> [key: type.name, value: type.id] end)

        types = [[key: "Choose a Type", value: "", disabled: "true", selected: "true"] | types]

        render(conn, "new.html", changeset: changeset, person: person, types: types)
    end
  end

  def create(conn, %{"address" => address_params}, org, _permissions) do
    address_params =
    address_params
      |> Map.put("person_id", person.id)

    with {:ok, _address} <- People.create_address(address_params, org) do
      conn
      |> put_flash(:success, "Document created successfully.")
      |> redirect(to: Routes.person_address_path(conn, :index, person))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        lookup = LookupTypes.get_lookup_by_name!(@type_ref, org)

        types =
          LookupTypes.list_types(lookup, org)
          |> Enum.map(fn type -> [key: type.name, value: type.id] end)

        conn
        |> put_flash(:danger, "There are errors on the page.")
        |> render("new.html", changeset: changeset, person: person, types: types)
    end
  end

  def show(conn, %{"id" => id}, org, _permissions) do
    address = Addresses.get_address!(id, org)
    render(conn, "show.html", address: address)
  end

  def edit(conn, %{"id" => id}, org, _permissions) do
    address = Addresses.get_address!(id, org)
    changeset = Addresses.change_address(address)
    render(conn, "edit.html", address: address, changeset: changeset)
  end

  def update(conn, %{"id" => id, "address" => address_params}, org, _permissions) do
    address = Addresses.get_address!(id, org)

    case Addresses.update_address(address, address_params, org) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address updated successfully.")
        |> redirect(to: Routes.address_path(conn, :show, address))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", address: address, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, org, _permissions) do
    address = Addresses.get_address!(id, org)
    {:ok, _address} = Addresses.delete_address(address, org)

    conn
    |> put_flash(:info, "Address deleted successfully.")
    |> redirect(to: Routes.address_path(conn, :index))
  end
end
