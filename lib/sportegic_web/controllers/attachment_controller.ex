defmodule SportegicWeb.AttachmentController do
  use SportegicWeb, :controller

  alias Sportegic.People

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"document_id" => document_id}, person, org, _permissions) do
    document = People.get_document!(person, document_id, org)
    render(conn, "index.html", document: document, person: person)
  end

  def delete(conn, %{"id" => attachment_id} = params, person, org, _permissions) do
    IO.inspect(params)
    attachment = People.get_attachment!(attachment_id, org)
    document = People.get_document!(person, params["document_id"], org)
    {:ok, _attachment} = People.delete_attachment(attachment, org)

    conn
    |> put_flash(:danger, "Attachment deleted successfully.")
    |> redirect(to: Routes.person_document_attachment_path(conn, :index, document, person))
  end
end
