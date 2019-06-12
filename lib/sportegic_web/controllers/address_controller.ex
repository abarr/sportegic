defmodule SportegicWeb.AddressController do
  use SportegicWeb, :controller

  alias Sportegic.People
  alias Sportegic.People.Address
  alias Sportegic.LookupTypes
  alias Sportegic.People

  # Allows for getting Types by LookupType
  @type_ref "Address Types"

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, person, org, _permissions) do
    addresses = People.list_addresses(person, org)
    render(conn, "index.html", addresses: addresses, person: person)
  end

  def new(conn, _params, person, org, _permissions) do
    changeset = People.change_address(%Address{})
    lookup = LookupTypes.get_lookup_by_name!(@type_ref, org)

    types =
      LookupTypes.list_types(lookup, org)
      |> Enum.map(fn type -> [key: type.name, value: type.id] end)

    types = [[key: "Choose a Type", value: "", disabled: "true", selected: "true"] | types]

    render(conn, "new.html", changeset: changeset, person: person, types: types)
  end

  def create(conn, %{"address" => address_params}, person, org, _permissions) do
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

  def edit(conn, %{"id" => id}, person, org, _permissions) do
    address = People.get_address!(person, id, org)
    changeset = People.change_address(address)

    types =
      LookupTypes.get_lookup_by_name!(@type_ref, org)
      |> LookupTypes.list_types(org)
      |> Enum.map(fn type -> [key: type.name, value: type.id] end)

    render(conn, "edit.html", address: address, changeset: changeset, types: types,person: person )
  end

  def update(conn, %{"id" => id, "address" => address_params}, person, org, _permissions) do
    address = People.get_address!(person, id, org)

    case People.update_address(address, address_params, org) do
      {:ok, _address} ->
        conn
        |> put_flash(:info, "Address updated successfully.")
        |> redirect(to: Routes.person_address_path(conn, :index, person))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", address: address, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, person, org, _permissions) do
    address = People.get_address!(person, id, org)
    {:ok, _address} = People.delete_address(address, org)

    conn
    |> put_flash(:danger, "Address deleted successfully.")
    |> redirect(to: Routes.person_address_path(conn, :index, person))
  end
end
