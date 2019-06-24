Sportegic.Accounts.create_user(%{"email" => "scott.robertson@crusaders.co.nz","password" => "password","verified" => true})
Sportegic.Accounts.create_user(%{"email" => "colin.mansbridge@crusaders.co.nz","password" => "password","verified" => true})
Sportegic.Accounts.create_user(%{"email" => "shane.fletcher@crusaders.co.nz","password" => "password","verified" => true})


Sportegic.Accounts.create_organisation(
  %{
  "display" => "Crusaders",
  "name" => "Crusaders",
  "home_city" => "Christchurch, New Zealand",
  "timezone" => "Pacific/Auckland"
  }
)

Sportegic.Accounts.create_organisations_users(%{user_id: 1, organisation_id: 1})
Sportegic.Accounts.create_organisations_users(%{user_id: 2, organisation_id: 1})
Sportegic.Accounts.create_organisations_users(%{user_id: 3, organisation_id: 1})

Sportegic.LookupTypes.create_default_lookups("crusaders")
Sportegic.LookupTypes.create_default_lookup_types("crusaders")
Sportegic.Users.create_default_roles("crusaders")
Sportegic.Users.create_default_categories("crusaders")
Sportegic.Users.create_default_permissions("crusaders")
Sportegic.Users.create_default_owner_permissions("crusaders")
Sportegic.Users.create_default_administrator_permissions("crusaders")

Sportegic.Users.create_user(
  %{
    firstname: "Colin",
    lastname: "Mansbridge",
    mobile_no: "21219999",
    country_code: "+64",
    user_id: "2",
    role_id: "1"
  },
  "crusaders"
)

Sportegic.Users.create_user(
  %{
    firstname: "Scott",
    lastname: "Robertson",
    mobile_no: "21212121",
    country_code: "+64",
    user_id: "1",
    role_id: "2"
  },
  "crusaders"
)

Sportegic.Users.create_user(
  %{
    firstname: "Shane",
    lastname: "Fletcher",
    mobile_no: "27676721",
    country_code: "+64",
    user_id: "3",
    role_id: "2"
  },
  "crusaders"
)

Sportegic.People.create_person(
  %{
    firstname: "Michael",
    lastname: "Alaalatoa",
    dob: "1991-08-28",
    email: "michael.alaalatoa@crusaders.co.nz",
    mobile: "+6423456789"
  },
  "crusaders"
)

Sportegic.People.create_person(
  %{
    firstname: "Harry",
    lastname: "Allan",
    dob: "1997-05-07",
    email: "harry.allan@crusaders.co.nz",
    mobile: "+6423498779"
  },
  "crusaders"
)

Sportegic.People.create_person(
  %{
    firstname: "Kieran",
    lastname: "Read",
    dob: "1985-10-26",
    email: "kieran.read@crusaders.co.nz",
    mobile: "+6423908779"
  },
  "crusaders"
)

Sportegic.People.create_person(
  %{
    firstname: "Jack",
    lastname: "Goodhue",
    dob: "1995-06-13",
    email: "jack.goodhue@crusaders.co.nz",
    mobile: "+6429878779"
  },
  "crusaders"
)
