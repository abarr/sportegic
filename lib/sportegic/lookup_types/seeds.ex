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
      },
      %{
        name: "Address Types",
        description: "Provides a list of address types that can be recorded"
      },
      %{
        name: "Playing Positions",
        description: "Provides a list of playing positions for Athlete Profiles"
      }, 
      %{
        name: "Performance Areas",
        description: "Key areas of performance for review"
      }, 
      %{
        name: "Performance Review Type",
        description: "Context for perfomance review records (e.g. Training or Game)"
      },
      %{
        name: "Performance Rating",
        description: "Rating values for performance reviews to allow trend reporting"
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
        name: "Feedback",
        lookup_id: 5
      },
      %{
        name: "Training",
        lookup_id: 5
      },
      %{
        name: "Illness",
        lookup_id: 5
      }

    ]
  end

  def get_default_address_types() do
    [
      %{
        name: "Primary",
        lookup_id: 6
      },
      %{
        name: "Secondary",
        lookup_id: 6
      }
    ]
  end

  def get_default_playing_positions() do
    [
      %{
        name: "Loose Head",
        lookup_id: 7
      },
      %{
        name: "Hooker",
        lookup_id: 7
      },
      %{
        name: "Tight Head",
        lookup_id: 7
      },
      %{
        name: "Left Lock",
        lookup_id: 7
      },
      %{
        name: "Right Lock",
        lookup_id: 7
      },
      %{
        name: "Number 6",
        lookup_id: 7
      },
      %{
        name: "Number 7",
        lookup_id: 7
      },
      %{
        name: "Number 8",
        lookup_id: 7
      },
      %{
        name: "Half Back",
        lookup_id: 7
      },
      %{
        name: "Flyhalf",
        lookup_id: 7
      },
      %{
        name: "Inside Centre",
        lookup_id: 7
      },
      %{
        name: "Outside Centre",
        lookup_id: 7
      },
      %{
        name: "Left Wing",
        lookup_id: 7
      },
      %{
        name: "Right Wing",
        lookup_id: 7
      },
      %{
        name: "Fullback",
        lookup_id: 7
      }

    ]
  end

  def get_default_performance_areas() do
    [
      %{
        name: "Attack",
        lookup_id: 8
      },
      %{
        name: "Starter Attack",
        lookup_id: 8
      },
      %{
        name: "Defence",
        lookup_id: 8
      },
      %{
        name: "Contact",
        lookup_id: 8
      },
      %{
        name: "Kicking",
        lookup_id: 8
      },
      %{
        name: "Lineout",
        lookup_id: 8
      },
      %{
        name: "Maul",
        lookup_id: 8
      },
      %{
        name: "Scrum",
        lookup_id: 8
      },
      %{
        name: "Our Kick Off",
        lookup_id: 8
      },
      %{
        name: "Their Kick Off",
        lookup_id: 8
      },
      %{
        name: "Skills",
        lookup_id: 8
      },
      %{
        name: "Other",
        lookup_id: 8
      }

    ]
  end

  def get_default_performance_review_context() do
    [
      %{
        name: "Training",
        lookup_id: 9
      },
      %{
        name: "Game",
        lookup_id: 9
      }
    ]
  end
  def get_default_performance_rating() do
      [
        %{
          name: "1 - Needs Improvement",
          lookup_id: 10
        },
        %{
          name: "2 - Meets Minimum Standard",
          lookup_id: 10
        },
        %{
          name: "3 - Exceeds Minimum",
          lookup_id: 10
        },
        %{
          name: "4 - Exceeds Expectations",
          lookup_id: 10
        }
      ]
    end

end
