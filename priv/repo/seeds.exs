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
