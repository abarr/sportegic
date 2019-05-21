defmodule Sportegic.People.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  # @versions [:original, :thumb]
  @versions [:original, :thumb]
  @acl :public_read

  def __storage, do: Arc.Storage.Local
  # def __storage, do: Arc.Storage.GCS

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Resize roiginal transformation:
  def transform(:original, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity north -extent 250x240 -format png", :png}
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity north -extent 150x150 -format png", :png}
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, _scope}) do
    "uploads/people/headshots/"
  end

  # To make the destination file the same as the version:
  def filename(version, _), do: version

  def filename(version, {_file, scope}) do
    "#{scope.id}_#{version}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, scope) do
    "https://ui-avatars.com/api/?name=#{scope.firstname}+#{scope.lastname}&size=200"
  end
end
