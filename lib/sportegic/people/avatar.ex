defmodule Sportegic.People.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition
  use Timex

  # To add a thumbnail version:
  # @versions [:original, :thumb]
  @versions [:original, :thumb]
  @acl :private

  
  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Resize roiginal transformation:
  def transform(:original, _) do
    {:convert, "-strip -thumbnail 280x250^ -gravity north -extent 280x240 -format png", :png}
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity north -extent 150x150 -format png", :png}
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "/people/#{scope.org}"
  end

  def filename(version, {file, scope}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))
    "#{scope.id}_#{version}_#{file_name}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, scope) do
    "https://ui-avatars.com/api/?name=#{scope.firstname}+#{scope.lastname}&size=200"
  end
end
