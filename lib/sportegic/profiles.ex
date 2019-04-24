defmodule Sportegic.Profiles do
  import Ecto.Query, warn: false
  
  alias __MODULE__
  alias Sportegic.Repo
  alias Sportegic.Profiles.Profile
  alias Sportegic.Profiles.Category
  alias Sportegic.Profiles.Permission
  alias Sportegic.Profiles.Role
  alias Sportegic.Profiles.Seeds

  def list_profiles(org) do
    Repo.all(Profile, prefix: org)
  end

  def get_profile!(id, org), do: Repo.get!(Profile, id, prefix: org)

  #  Get profile using user_id from con
  def get_profile(user_id, org) do
    profile =
      Profile
      |> where([p], p.user_id == ^user_id)
      |> Repo.one(prefix: org)

    {:ok, profile}
  end

  def create_profile(attrs \\ %{}, org) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def update_profile(%Profile{} = profile, attrs, org) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end

  def list_roles(org) do
    Repo.all(Role, prefix: org)
  end

  def get_role!(id, org), do: Repo.get!(Role, id, prefix: org)

  def create_role(attrs \\ %{}, org) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_default_roles(org) do
    roles = Seeds.get_default_roles_list()
    list = Enum.map(roles, &create_role(&1, org))
    {:ok, list}
  end

  def update_role(%Role{} = role, attrs, org) do
    role
    |> Role.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def delete_role(%Role{} = role, org) do
    Repo.delete(role, prefix: org)
  end

  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end

  def list_categories(org) do
    Repo.all(Category, prefix: org)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}, org) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_default_categories(org) do
    categories = Seeds.get_default_permission_categories()
    list = Enum.map(categories, &create_category(&1, org))
    {:ok, list}
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  def list_permissions(org) do
    query = from p in Permission, 
    join: c in Category, 
    on: p.category_id == c.id, 
    select: %{permission_id: p.id, name: p.name, category: c.name, category_id: c.id }
    
    query
    |> Repo.all(prefix: org)
    |> Enum.group_by(fn p -> p.category end)
    |> Enum.map(fn {k, v} -> {k, Enum.map(v, &Map.delete(&1, :category))} end)
    |> Map.new
  end

  def get_permission!(id, org), do: Repo.get!(Permission, id, org)

  def create_permission(attrs \\ %{}, org) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_default_permissions(org) do
    permissions = Seeds.get_default_permissions_list()
    categories = Profiles.list_categories(org)

    for category <- categories do
      Enum.map(permissions, fn permission ->
        attrs = Map.put(permission, :category_id, category.id)
        IO.inspect(attrs, label: "PERMISSION MAP:")
        create_permission(attrs, org)
      end)
    end

    {:ok, []}
  end
end
