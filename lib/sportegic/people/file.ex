defmodule Sportegic.People.File do
  use Arc.Definition
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  # @versions [:original, :thumb]
  @versions [:original]
  @acl :private

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png .doc .docx .pdf) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  # def transform(:original, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity north -extent 250x240 -format png", :png}
  # end

  def filename(version, {file, scope}) do
    case scope.document_id || scope.insurance_policy_id || scope.visa_id do
      nil -> {:error, "No associated ID in scope"}  
      id -> 
        file_name = Path.basename(file.file_name, Path.extname(file.file_name))
        "#{id}_#{scope.uuid}_#{version}_#{file_name}"
    end
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "/documents/#{scope.org}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope) do
    ""
  end
end
