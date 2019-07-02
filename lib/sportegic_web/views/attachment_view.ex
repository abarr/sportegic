defmodule SportegicWeb.AttachmentView do
    use SportegicWeb, :view

    alias Sportegic.People.File

    def display_attachment_link(attachment) do
        {attachment.file, attachment}
        |> File.url(:original, signed: true)
      end
    
end