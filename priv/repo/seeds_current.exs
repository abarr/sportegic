Sportegic.Accounts.create_user(%{"email" => "nick.ryan@melbournerebels.com.au","password" => "password","verified" => true})
Sportegic.Accounts.create_user(%{"email" => "andrew@foxtail.consulting","password" => "password","verified" => true})


Sportegic.Accounts.create_organisation(
  %{
  "display" => "Rebels Rugby",
  "name" => "Melbourne Rebels",
  "home_city" => "Melbourne VIC 3000, Australia",
  "timezone" => "Australia/Melbourne"
  }
)

Sportegic.Accounts.create_organisations_users(%{user_id: 1, organisation_id: 1})
Sportegic.Accounts.create_organisations_users(%{user_id: 2, organisation_id: 1})

Sportegic.LookupTypes.create_default_lookups("rebels_rugby")
Sportegic.LookupTypes.create_default_lookup_types("rebels_rugby")
Sportegic.Users.create_default_roles("rebels_rugby")
Sportegic.Users.create_default_categories("rebels_rugby")
Sportegic.Users.create_default_permissions("rebels_rugby")
Sportegic.Users.create_default_owner_permissions("rebels_rugby")
Sportegic.Users.create_default_administrator_permissions("rebels_rugby")

Sportegic.Users.create_user(
  %{
    firstname: "Nick",
    lastname: "Ryan",
    mobile_no: "0411222333",
    country_code: "+61",
    user_id: "1",
    role_id: "1"
  },
  "rebels_rugby"
)

Sportegic.Users.create_user(
  %{
    firstname: "Andrew",
    lastname: "Barr",
    mobile_no: "0413306150",
    country_code: "+61",
    user_id: "2",
    role_id: "2"
  },
  "rebels_rugby"
)

Sportegic.People.create_person(
  %{
    "firstname" => "Reece",
    "lastname" => "Hodge",
    "dob" => "1994-08-26",
    "email" => "reece.hodge@melbournerebels.com.au",
    "mobile" => "+610412654987"
  },
  "rebels_rugby"
)

Sportegic.People.create_person(
  %{
    "firstname" =>"Angus",
    "lastname" => "Cottrell",
    "dob" => "1989-11-20",
    "email" => "reece.hodge@melbournerebels.com.au",
    "mobile" => "+610412987445"
  },
  "rebels_rugby"
)

# Sportegic.People.create_person(
#   %{
#     firstname: "Campbell",
#     lastname: "Magnay",
#     dob: "1996-11-10",
#     email: "campbell.magnay@melbournerebels.com.au",
#     mobile: "+610412459760"
#   },
#   "rebels_rugby"
# )

# Sportegic.People.create_person(
#   %{
#     firstname: "Isi",
#     lastname: "Naisarani",
#     dob: "1995-02-14",
#     email: "isi.naisarani@melbournerebels.com.au",
#     mobile: "+610412342450"
#   },
#   "rebels_rugby"
# )

# Sportegic.People.create_person(
#   %{
#     firstname: "Matt",
#     lastname: "Phillip",
#     dob: "1994-03-07",
#     email: "matt.phillip@melbournerebels.com.au",
#     mobile: "+610412098456"
#   },
#   "rebels_rugby"
# )

# #  Note One
Sportegic.Notes.create_note(
  %{
    event_date: DateTime.utc_now(),
    subject: "Players involved in altercation at training",
    details:
      "<p>There has been an incident at training between Reece and Angus. The matter was resolved immediatly</p>",
    user_id: "1"
  },
  "rebels_rugby"
)

Sportegic.Notes.create_note_type(
  %{
    note_id: "1",
    type_id: "12"
  },
  "rebels_rugby"
)

Sportegic.Notes.create_note_type(
  %{
    note_id: "1",
    type_id: "14"
  },
  "rebels_rugby"
)

Sportegic.Notes.create_note_person(
  %{
    note_id: "1",
    person_id: "1"
  },
  "rebels_rugby"
)

Sportegic.Notes.create_note_person(
  %{
    note_id: "1",
    person_id: "2"
  },
  "rebels_rugby"
)

#  Note Two
Sportegic.Notes.create_note(
  %{
    event_date: DateTime.utc_now(),
    subject: "School visit - great feedback",
    details:
      "<p>Matt and Isi visit St John's school. We had a fantastic email from the Principal telling us how good the boys were.</p>",
    user_id: "2"
  },
  "rebels_rugby"
)

Sportegic.Notes.create_note_type(
  %{
    note_id: "2",
    type_id: "14"
  },
  "rebels_rugby"
)

Sportegic.Notes.create_note_person(
  %{
    note_id: "2",
    person_id: "2"
  },
  "rebels_rugby"
)

Sportegic.Notes.create_note_person(
  %{
    note_id: "2",
    person_id: "1"
  },
  "rebels_rugby"
)


Sportegic.Tasks.create_task(
  %{
    action:
      "<p>Please call Matt and Isi and congratulate them on a great outcome.</>",
    due_date: Timex.to_datetime({{2019, 07, 01}, {0, 0, 0}}),
    completed: false,
    note_id: "2",
    user_id: "2",
    assignee_id: "1"
  },
  "rebels_rugby"
)

