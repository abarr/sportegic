defmodule SportegicWeb.VisaController do
  use SportegicWeb, :controller

  alias Sportegic.People
  alias Sportegic.People.{Visa, Attachment}
  alias Sportegic.LookupTypes

  # Allows for getting Types by LookupType
  @type_ref "Visa Types"

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "view:visa_permissions", "", permissions) do
      visas = People.list_visas(person, org)
      render(conn, "index.html", visas: visas, person: person)
    end
  end

  def new(conn, _params, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "create:visa_permissions", "", permissions) do
      changeset = People.change_visa(%Visa{ attachments: [%Attachment{}]})
      lookup = LookupTypes.get_lookup_by_name!(@type_ref, org)

      types =
        LookupTypes.list_types(lookup, org)
        |> Enum.map(fn type -> [key: type.name, value: type.id] end)

      types = [[key: "Choose a Type", value: "", disabled: "true", selected: "true"] | types]

      render(conn, "new.html", changeset: changeset, person: person, types: types)
    end
  end

  def create(conn, %{"visa" => visa_params}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "create:visa_permissions", "", permissions) do
      visa_params =
      visa_params
        |> Map.put("person_id", person.id)

      with {:ok, _visa} <- People.create_visa(visa_params, org) do
        conn
        |> put_flash(:success, "Visa created successfully.")
        |> redirect(to: Routes.person_visa_path(conn, :index, person))
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
  end

  def show(conn, %{"id" => id}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "view:visa_permissions", "", permissions) do
      visa = People.get_visa!(person, id, org)
      render(conn, "show.html", visa: visa, person: person)
    end
  end

  def edit(conn, %{"id" => id}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "edit:visa_permissions", "", permissions) do
      visa = People.get_visa!(person, id, org)
      changeset = People.change_visa(visa)

      types =
        LookupTypes.get_lookup_by_name!(@type_ref, org)
        |> LookupTypes.list_types(org)
        |> Enum.map(fn type -> [key: type.name, value: type.id] end)

      render(conn, "edit.html",
        visa: visa,
        changeset: changeset,
        person: person,
        types: types
      )
    end
  end

  def update(conn, %{"id" => id, "visa" => visa_params}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "edit:visa_permissions", "", permissions) do
      visa = People.get_visa!(person, id, org)

      case People.update_visa(visa, visa_params, org) do
        {:ok, _visa} ->
          conn
          |> put_flash(:info, "Visa updated successfully.")
          |> redirect(to: Routes.person_visa_path(conn, :index, person))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:danger, "Unable to update the visa")
          |> render("edit.html", visa: visa, changeset: changeset, person: person)
      end
    end
  end

  def delete(conn, %{"id" => id}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "delete:visa_permissions", "", permissions) do
      visa = People.get_visa!(person, id, org)
      {:ok, _visa} = People.delete_visa(visa, org)

      conn
      |> put_flash(:danger, "Visa deleted successfully.")
      |> redirect(to: Routes.person_visa_path(conn, :index, person))
    end
  end
end
