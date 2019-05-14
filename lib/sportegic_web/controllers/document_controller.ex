defmodule SportegicWeb.DocumentController do
  use SportegicWeb, :controller

  alias Sportegic.People
  alias Sportegic.People.{Document, Attachment}
  alias Sportegic.LookupTypes

  # Allows for getting Types by LookupType
  @type_ref "Document Types"

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, person, org, _permissions) do
    documents = People.list_documents(person, org)
    render(conn, "index.html", documents: documents, person: person)
  end

  def new(conn, _params, person, org, _permissions) do
    changeset = People.change_document(%Document{attachments: [%Attachment{}]})
    lookup = LookupTypes.get_lookup_by_name!(@type_ref, org)

    types =
      LookupTypes.list_types(lookup, org)
      |> Enum.map(fn type -> [key: type.name, value: type.id] end)

    types = [[key: "Choose a Type", value: ""] | types]

    render(conn, "new.html", changeset: changeset, person: person, types: types)
  end

  def create(conn, %{"document" => document_params} = params, person, org, _permissions) do
    document_params =
      document_params
      |> Map.put("person_id", person.id)

    with {:ok, document} <- People.create_document(document_params, org) do
      document_params["attachments"]
      |> Enum.map(fn f -> %{file: f, document_id: document.id} end)
      |> Enum.map(&People.create_attachment(&1, org))

      conn
      |> put_flash(:info, "Document created successfully.")
      |> redirect(to: Routes.person_document_path(conn, :index, person))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        lookup = LookupTypes.get_lookup_by_name!(@type_ref, org)
        types =
          LookupTypes.list_types(lookup, org)
          |> Enum.map(fn type -> [key: type.name, value: type.id] end)
        render(conn, "new.html", changeset: changeset, person: person, types: types)
    end
  end

  def show(conn, %{"id" => id}, person, org, _permissions) do
    document = People.get_document!(person, id, org)
    render(conn, "show.html", document: document, person: person)
  end

  def edit(conn, %{"id" => id}, person, org, _permissions) do
    document = People.get_document!(person, id, org)
    changeset = People.change_document(document)

    types =
      LookupTypes.get_lookup_by_name!(@type_ref, org)
      |> LookupTypes.list_types(org)
      |> Enum.map(fn type -> [key: type.name, value: type.id] end)

    render(conn, "edit.html",
      document: document,
      changeset: changeset,
      person: person,
      types: types
    )
  end

  def update(conn, %{"id" => id, "document" => document_params}, person, org, _permissions) do
    document = People.get_document!(person, id, org)

    case People.update_document(document, document_params, org) do
      {:ok, _document} ->
        conn
        |> put_flash(:info, "Document updated successfully.")
        |> redirect(to: Routes.person_document_path(conn, :index, person))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", document: document, changeset: changeset, person: person)
    end
  end

  def delete(conn, %{"id" => id}, person, org, _permissions) do
    document = People.get_document!(person, id, org)
    {:ok, _document} = People.delete_document(document, org)

    conn
    |> put_flash(:info, "Document deleted successfully.")
    |> redirect(to: Routes.person_document_path(conn, :index, person))
  end
end
