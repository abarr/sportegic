defmodule Sportegic.Users.Seeds do
  def get_default_roles_list() do
    [
      %{
        name: "Account Owner",
        description:
          "This role is applied to the User who originally created the organisation."
      },
      %{
        name: "Administrator",
        description:
          "A default Role created as a convenience. It has all permissions assigned, however can be edited as required."
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
      %{name: "Role Permissions", key: "role_permissions"},
      %{name: "People Permissions", key: "people_permissions"},
      %{name: "Address Permissions", key: "address_permissions"},
      %{name: "Document Permissions", key: "document_permissions"},
      %{name: "Insurance Permissions", key: "insurance_permissions"},
      %{name: "Visa Permissions", key: "visa_permissions"},
      %{name: "Profile Permissions", key: "profile_permissions"},
      %{name: "Squad Permissions", key: "squad_permissions"},
      %{name: "Note Permissions", key: "note_permissions"},
      %{name: "Task Permissions", key: "task_permissions"},
      %{name: "Lookup Permissions", key: "lookup_permissions"},
      %{name: "Performance Permissions", key: "performance_permissions"}
    ]
  end
end
