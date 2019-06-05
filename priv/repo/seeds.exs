Sportegic.Accounts.create_user(%{
  "email" => "a@t.com",
  "password" => "password",
  "verified" => "true"
})

Sportegic.Accounts.create_organisation(%{
  "display" => "Collingwood",
  "name" => "Collingwood"
})

Sportegic.Accounts.create_organisations_users(%{user_id: 1, organisation_id: 1})

Sportegic.LookupTypes.create_default_lookups("collingwood")
Sportegic.LookupTypes.create_default_lookup_types("collingwood")
Sportegic.Users.create_default_roles("collingwood")
Sportegic.Users.create_default_categories("collingwood")
Sportegic.Users.create_default_permissions("collingwood")
Sportegic.Users.create_default_owner_permissions("collingwood")

# Create an account owner

Sportegic.Users.create_user(
  %{
    firstname: "Andrew",
    lastname: "Barr",
    mobile: "+61413306150",
    user_id: "1",
    role_id: "1"
  },
  "collingwood"
)

# Create some players

Sportegic.People.create_person(
  %{
    firstname: "Jaidyn",
    lastname: "Stephenson",
    dob: "1999-01-15",
    email: "jaidyn@collingwood.com",
    mobile: "+61422333444"
  },
  "collingwood"
)

Sportegic.People.create_person(
  %{
    firstname: "Jordan",
    lastname: "De Goey",
    dob: "1996-03-15",
    email: "jordon@collingwood.com",
    mobile: "+61422444555"
  },
  "collingwood"
)

Sportegic.People.create_person(
  %{
    firstname: "Daniel",
    lastname: "Wells",
    dob: "1985-02-03",
    email: "daniel@collingwood.com",
    mobile: "+61422555666"
  },
  "collingwood"
)

Sportegic.People.create_person(
  %{
    firstname: "Adam",
    lastname: "Treloar",
    dob: "1993-03-09",
    email: "adam@collingwood.com",
    mobile: "+61422666777"
  },
  "collingwood"
)

Sportegic.People.create_person(
  %{
    firstname: "Brodie",
    lastname: "Grundy",
    dob: "1994-04-15",
    email: "brodie@collingwood.com",
    mobile: "+61422777888"
  },
  "collingwood"
)

Sportegic.People.create_person(
  %{
    firstname: "Tyson",
    lastname: "Goldstack",
    dob: "1987-05-22",
    email: "tyson@collingwood.com",
    mobile: "+61422888999"
  },
  "collingwood"
)

Sportegic.People.create_person(
  %{
    firstname: "Jamie",
    lastname: "Elliot",
    dob: "1992-08-21",
    email: "jamie@collingwood.com",
    mobile: "+61422999888"
  },
  "collingwood"
)


#  Create some notes

#  Note One
Sportegic.Notes.create_note(%{
  event_date: "2019-05-15",
  subject: "Players involved in altercation at training",
  details: "<p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p><ul>
  <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</li>
  <li>Aliquam tincidunt mauris eu risus.</li>
  <li>Vestibulum auctor dapibus neque.</li>
  </ul>",
  user_id: "1"

}, "collingwood")

Sportegic.Notes.create_note_type(%{
  note_id: "1",
  type_id: "12"
}, "collingwood")

Sportegic.Notes.create_note_type(%{
  note_id: "1",
  type_id: "14"
}, "collingwood")

Sportegic.Notes.create_note_person(%{
  note_id: "1",
  person_id: "1"
}, "collingwood")
Sportegic.Notes.create_note_person(%{
  note_id: "1",
  person_id: "2"
}, "collingwood")
Sportegic.Notes.create_note_person(%{
  note_id: "1",
  person_id: "3"
}, "collingwood")

#  Note Two
Sportegic.Notes.create_note(%{
  event_date: "2019-06-04",
  subject: "Players involved in altercation at training",
  details: "<p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p><ul>
  <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</li>
  <li>Aliquam tincidunt mauris eu risus.</li>
  <li>Vestibulum auctor dapibus neque.</li>
  </ul>",
  user_id: "1"

}, "collingwood")

Sportegic.Notes.create_note_type(%{
  note_id: "2",
  type_id: "16"
}, "collingwood")

Sportegic.Notes.create_note_type(%{
  note_id: "2",
  type_id: "15"
}, "collingwood")

Sportegic.Notes.create_note_person(%{
  note_id: "2",
  person_id: "5"
}, "collingwood")

#  Note Three
Sportegic.Notes.create_note(%{
  event_date: "2019-06-04",
  subject: "Excellent feedback from school visit",
  details: "<p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p><ul>
  <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</li>
  <li>Aliquam tincidunt mauris eu risus.</li>
  <li>Vestibulum auctor dapibus neque.</li>
  </ul>",
  user_id: "1"

}, "collingwood")

Sportegic.Notes.create_note_type(%{
  note_id: "3",
  type_id: "14"
}, "collingwood")



Sportegic.Notes.create_note_person(%{
  note_id: "3",
  person_id: "5"
}, "collingwood")

Sportegic.Notes.create_note_person(%{
  note_id: "3",
  person_id: "1"
}, "collingwood")



