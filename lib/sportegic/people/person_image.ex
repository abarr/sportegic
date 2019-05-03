defmodule Sportegic.People.PersonImage do
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
      IO.puts("VALIDATE ++++++++++++++++++++++++++++++++++++++++++++++++")
      ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
    end
  
    # Define a thumbnail transformation:
    def transform(:original, _) do
      IO.puts("TRANSFORM ++++++++++++++++++++++++++++++++++++++++++++++++")
      {:convert, "-strip -thumbnail 250x250^ -gravity north -extent 250x240 -format png", :png}
    end
  
    # Override the storage directory:
    def storage_dir(_version, {_file, person}) do
      IO.puts("STORAGE ++++++++++++++++++++++++++++++++++++++++++++++++")
      "uploads/people/#{person.firstname}_#{person.lastname}_#{person.dob}"
    end
  
    # Provide a default URL if there hasn't been a file uploaded
    def default_url(_version, person) do
      "https://ui-avatars.com/api/?name=#{person.firstname}+#{person.lastname}&size=200"
    end
  
end