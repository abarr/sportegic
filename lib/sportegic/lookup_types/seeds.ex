defmodule Sportegic.LookupTypes.Seeds do
  def get_default_lookups_list() do
    [
      %{
        name: "Document Types",
        description: "Provides a list of document types that people can create and upload"
      },
      %{
        name: "Visa Types",
        description: "Provides a list of visas types held by the traveller"
      },
      %{
        name: "Insurance Types",
        description: "Provides a list of insurance policy types held by the person"
      },
      %{
        name: "Vehicle Types",
        description: "Provides a list of vehicle types that people can record"
      },
      %{
        name: "Note Tags",
        description: "Provides a list of tags for categorising and weighting notes"
      }
    ]
  end

  def get_default_document_types() do
    [
      %{
        name: "Passport",
        lookup_id: 1
      },
      %{
        name: "Drivers Licence",
        lookup_id: 1
      }
    ]
  end

  def get_default_visa_types() do
    [
      %{
        name: "Work Permit",
        lookup_id: 2
      },
      %{
        name: "Residency",
        lookup_id: 2
      }
    ]
  end

  def get_default_insurance_types() do
    [
      %{
        name: "Life Insurance",
        lookup_id: 3
      },
      %{
        name: "Total Permanent Disability",
        lookup_id: 3
      },
      %{
        name: "Income Protection",
        lookup_id: 3
      },
      %{
        name: "Health Insurance",
        lookup_id: 3
      }
    ]
  end

  def get_default_vehicle_types() do
    [
      %{
        name: "Car",
        lookup_id: 4
      },
      %{
        name: "Motorbike",
        lookup_id: 4
      },
      %{
        name: "Other",
        lookup_id: 4
      }
    ]
  end

  def get_default_notes_tags() do
    [
      %{
        name: "Fight",
        lookup_id: 5
      },
      %{
        name: "Family",
        lookup_id: 5
      },
      %{
        name: "Positive Feedback",
        lookup_id: 5
      }
    ]
  end
end
