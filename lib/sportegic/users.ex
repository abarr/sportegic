defmodule Sportegic.Users do
  import Ecto.Query, warn: false

  alias __MODULE__
  alias Sportegic.Repo
  alias Sportegic.Users.User
  alias Sportegic.Users.Category
  alias Sportegic.Users.Permission
  alias Sportegic.Users.Role
  alias Sportegic.Users.Seeds
  alias Sportegic.Users.RolesPermissions

  def list_users(org) do
    Repo.all(User, prefix: org)
  end

  def get_user!(id, org), do: Repo.get!(User, id, prefix: org)

  #  Get profile using user_id from con
  def get_user(user_id, org) do
    profile =
      User
      |> where([p], p.user_id == ^user_id)
      |> Repo.one(prefix: org)

    {:ok, profile}
  end

  def create_user(attrs \\ %{}, org) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def update_user(%User{} = profile, attrs, org) do
    profile
    |> User.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def change_user(%User{} = profile) do
    User.changeset(profile, %{})
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
    role
    |> Role.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:permissions, permissions, [])
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
    categories = Users.list_categories(org)

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
