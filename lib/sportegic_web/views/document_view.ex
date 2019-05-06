defmodule SportegicWeb.DocumentView do
  use SportegicWeb, :view

  alias Sportegic.People.PersonDocument

  def display_document_link(document) do
    {document.file, document}
    |> PersonDocument.url()
  end
end
