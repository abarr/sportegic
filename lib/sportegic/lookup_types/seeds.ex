defmodule Sportegic.LookupTypes.Seeds do
  def get_default_lookups_list() do
    [
      %{
        name: "Document Types",
        key: "document_types",
        description: "Provides a list of document types that people can create and upload"
      },
      %{
        name: "Visa Types",
        key: "visa_types",
        description: "Provides a list of visas types held by the traveller"
      },
      %{
        name: "Insurance Types",
        key: "insurance_types",
        description: "Provides a list of insurance policy types held by the person"
      },
      %{
        name: "Vehicle Types",
        key: "vehicle_types",
        description: "Provides a list of vehicle types that people can record"
      },
      %{
        name: "Note Tags",
        key: "note_tags",
        description: "Provides a list of tags for categorising and weighting notes"
      },
      %{
        name: "Address Types",
        key: "address_types",
        description: "Provides a list of address types that can be recorded"
      },
      %{
        name: "Playing Positions",
        key: "playing_positions",
        description: "Provides a list of playing positions for Athlete Profiles"
      }, 
      %{
        name: "Performance Areas",
        key: "performance_areas",
        description: "Key areas of performance for review"
      }, 
      %{
        name: "Performance Review Type",
        key: "performance_review_type",
        description: "Context for perfomance review records (e.g. Training or Game)"
      },
      %{
        name: "Performance Rating",
        key: "performance_rating",
        description: "Rating values for performance reviews to allow trend reporting"
      }
    ]
  end

  def get_default_document_types() do
    [
      %{
        name: "Passport",
        key: "passport_document_types",
        lookup_id: 1
      },
      %{
        name: "Drivers Licence",
        key: "drivers_licence_document_types",
        lookup_id: 1
      }
    ]
  end

  def get_default_visa_types() do
    [
      %{
        name: "Work Permit",
        key: "work_permit_visa_types",
        lookup_id: 2
      },
      %{
        name: "Residency",
        key: "residency_visa_types",
        lookup_id: 2
      }
    ]
  end

  def get_default_insurance_types() do
    [
      %{
        name: "Life Insurance",
        key: "life_insurance_insurance_types",
        lookup_id: 3
      },
      %{
        name: "Total Permanent Disability",
        key: "total_permanent_disability_insurance_types",
        lookup_id: 3
      },
      %{
        name: "Income Protection",
        key: "income_protection_insurance_types",
        lookup_id: 3
      },
      %{
        name: "Health Insurance",
        key: "health_insurance_insurance_types",
        lookup_id: 3
      }
    ]
  end

  def get_default_vehicle_types() do
    [
      %{
        name: "Car",
        key: "car_vehicle_types",
        lookup_id: 4
      },
      %{
        name: "Motorbike",
        key: "motorbike_vehicle_types",
        lookup_id: 4
      },
      %{
        name: "Other",
        key: "other_vehicle_types",
        lookup_id: 4
      }
    ]
  end

  def get_default_notes_tags() do
    [
      %{
        name: "Fight",
        key: "fight_note_tags",
        lookup_id: 5
      },
      %{
        name: "Family",
        key: "family_note_tags",
        lookup_id: 5
      },
      %{
        name: "Feedback",
        key: "feedback_note_tags",
        lookup_id: 5
      },
      %{
        name: "Training",
        key: "training_note_tags",
        lookup_id: 5
      },
      %{
        name: "Illness",
        key: "illness_note_tags",
        lookup_id: 5
      }

    ]
  end

  def get_default_address_types() do
    [
      %{
        name: "Primary",
        key: "primary_address_types",
        lookup_id: 6
      },
      %{
        name: "Secondary",
        key: "secondary_address_types",
        lookup_id: 6
      }
    ]
  end

  def get_default_playing_positions() do
    [
      %{
        name: "Loose Head",
        key: "loose_head_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Hooker",
        key: "hooker_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Tight Head",
        key: "tight_head_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Left Lock",
        key: "left_lock_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Right Lock",
        key: "right_lock_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Number 6",
        key: "number_6_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Number 7",
        key: "number_7_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Number 8",
        key: "number_8_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Half Back",
        key: "half_back_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Flyhalf",
        key: "flyhalf_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Inside Centre",
        key: "inside_centre_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Outside Centre",
        key: "outside_centre_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Left Wing",
        key: "left_wing_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Right Wing",
        key: "right_wing_playing_positions",
        lookup_id: 7
      },
      %{
        name: "Fullback",
        key: "fullback_playing_positions",
        lookup_id: 7
      }

    ]
  end

  def get_default_performance_areas() do
    [
      %{
        name: "Attack",
        key: "attack_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Starter Attack",
        key: "starter_attack_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Defence",
        key: "defence_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Contact",
        key: "contact_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Kicking",
        key: "kicking_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Lineout",
        key: "lineout_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Maul",
        key: "maul_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Scrum",
        key: "scrum_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Our Kick Off",
        key: "our_kick_off_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Their Kick Off",
        key: "their_kick_off_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Skills",
        key: "skills_performance_areas",
        lookup_id: 8
      },
      %{
        name: "Other",
        key: "other_performance_areas",
        lookup_id: 8
      }

    ]
  end

  def get_default_performance_review_context() do
    [
      %{
        name: "Training",
        key: "training_performance_review_type",
        lookup_id: 9
      },
      %{
        name: "Game",
        key: "game_performance_review_type",
        lookup_id: 9
      }
    ]
  end
  def get_default_performance_rating() do
      [
        %{
          name: "Needs Improvement",
          key: "needs_improvement_performance_rating",
          lookup_id: 10
        },
        %{
          name: "Meets Minimum",
          key: "meets_minimum_performance_rating",
          lookup_id: 10
        },
        %{
          name: "Exceeds Minimum",
          key: "exceeds_minimum_performance_rating",
          lookup_id: 10
        },
        %{
          name: "Exceeds Expectations",
          key: "exceeds_expectations_performance_rating",
          lookup_id: 10
        }
      ]
    end

end
