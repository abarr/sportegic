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

    
    def index(conn, %{ "document_id" => document_id }, person, org, _permissions) do
        document = People.get_document!(person, document_id, org) 
        render(conn, "index.html", document: document, person: person)
    end
    
end