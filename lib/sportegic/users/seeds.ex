defmodule Sportegic.Users.Seeds do
  def get_default_roles_list() do
    [
      %{
        name: "Account Owner",
        description:
          "This role is applied to the User who originally created the organisation. There must always be a minimum of one Account Owner"
      }
    ]
  end

  def get_default_permissions_list() do
    [
      %{name: "View"},
      %{name: "Create"},
      %{name: "Edit"},
      %{name: "Delete"}
    ]
  end

  def get_default_permission_categories() do
    [
      %{name: "User Permissions", key: "user_permissions"},
      %{name: "People Permissions", key: "people_permissions"},
      %{name: "Role Permissions", key: "role_permissions"}
    ]
  end
end
