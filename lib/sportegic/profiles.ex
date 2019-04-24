defmodule Sportegic.Profiles do
  import Ecto.Query, warn: false

  alias __MODULE__
  alias Sportegic.Repo
  alias Sportegic.Profiles.Profile
  alias Sportegic.Profiles.Category
  alias Sportegic.Profiles.Permission
  alias Sportegic.Profiles.Role
  alias Sportegic.Profiles.Seeds
  alias Sportegic.Profiles.RolesPermissions

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

  def get_role!(id, org) do
    Role
    |> Repo.get!(id, prefix: org)
    |> Repo.preload(:permissions)
  end

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

  def update_role(%Role{} = role, attrs, permissions, org) do
    # role
    # |> IO.inspect()
    # |> Ecto.Changeset.change(attrs)
    # |> IO.inspect()
    # |> Ecto.Changeset.put_assoc(:permissions, permissions, [])
    # |> IO.inspect()
    # |> Repo.update(prefix: org)

    role
    |> IO.inspect()
    |> Role.changeset(attrs)
    |> IO.inspect()
    |> Ecto.Changeset.put_assoc(:permissions, permissions, [])
    |> IO.inspect()
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
    query =
      from(p in Permission,
        join: c in Category,
        on: p.category_id == c.id,
        select: %{permission_id: p.id, name: p.name, category: c.name}
      )

    query
    |> Repo.all(prefix: org)
    |> Enum.group_by(fn p -> p.category end)
    |> Enum.map(fn {k, v} -> {k, Enum.map(v, &Map.delete(&1, :category))} end)
    |> Map.new()
  end

  def list_permissions(ids, org) do
    Permission
    |> where([p], p.id in ^ids)
    |> Repo.all(prefix: org)
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
        create_permission(attrs, org)
      end)
    end

    {:ok, []}
  end

  def list_roles_permissions(id, org) do
    query =
      from(rp in RolesPermissions,
        join: p in Permission,
        on: rp.permission_id == p.id and rp.role_id == ^id,
        join: c in Category,
        on: p.category_id == c.id,
        select: %{permission_id: p.id}
      )

    query
    |> Repo.all(prefix: org)
    |> Enum.map(fn %{permission_id: v} -> v end)
  end

  def get_roles_permissions!(id, org), do: Repo.get!(RolesPermissions, id, prefix: org)

  def create_roles_permissions(attrs \\ %{}, org) do
    %RolesPermissions{}
    |> RolesPermissions.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def create_role_permissions(role_id, permissions, org) do
    Enum.map(permissions, fn v ->
      attrs = Map.new([{:role_id, role_id}, {:permission_id, String.to_integer(v)}])
      create_roles_permissions(attrs, org)
    end)

    {:ok, []}
  end

  def delete_roles_permissions(%RolesPermissions{} = roles_permissions, org) do
    Repo.delete(roles_permissions, prefix: org)
  end

  def change_roles_permissions(%RolesPermissions{} = roles_permissions) do
    RolesPermissions.changeset(roles_permissions, %{})
  end
end
