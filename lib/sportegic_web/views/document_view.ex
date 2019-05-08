defmodule SportegicWeb.DocumentView do
  use SportegicWeb, :view

  alias Sportegic.People.File

  def display_document_link(document) do
    {document.file, document}
    |> File.url()
  end
end
