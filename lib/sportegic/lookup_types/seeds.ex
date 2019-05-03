defmodule Sportegic.LookupTypes.Seeds do
  def get_default_lookups_list() do
    [
      %{
        name: "Document Types",
        description:
          "Provides a list of document types that people can create and upload"
      },
      %{
        name: "Vehicle Types",
        description:
          "Provides a list of vehicle types that people can record"
      }
    ]
  end

  
end
