defmodule Sportegic.People.PersonDocument do
  use Arc.Definition
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  # @versions [:original, :thumb]
  @versions [:original]
  @acl :public_read

  def __storage, do: Arc.Storage.Local
  # def __storage, do: Arc.Storage.GCS

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png .doc .docx .pdf) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  # def transform(:original, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity north -extent 250x240 -format png", :png}
  # end

  # Override the storage directory:
  def storage_dir(version, {file, document}) do
    id = Integer.to_string(document.person_id)
    "uploads/people/documents/" <> id
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, document) do
    ""
  end
end
