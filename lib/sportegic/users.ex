defmodule Sportegic.Users do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  use Timex

  alias __MODULE__
  alias Sportegic.Repo
  alias Sportegic.Users.{User, Invitation, Category, Permission, Role, Seeds, RolesPermissions}
  alias Sportegic.Communication.Token

  defdelegate authorize(action, user, params), to: Sportegic.Users.Authorisation

  # Get user bu User table id
  def get_user!(id, org), do: Repo.get!(User, id, prefix: org)

  def list_users(org) do
    User
    |> Repo.all(prefix: org)
    |> Repo.preload(:role)
  end

  #  Get user using user_id from from Account user table (Public Schema)
  def get_user(user_id, org) do
    case Repo.get_by(User, [user_id: user_id], prefix: org) do
      nil -> {:ok, nil}
      {:error, msg} -> {:error, msg}
      user -> {:ok, user}
    end
  end

  def get_user_by_name(name, org) do
    case name do
      nil -> {:error, "Please enter a valid User"}
      name when is_binary(name) ->
        User
          |> Repo.get_by([fullname: name], prefix: org)
        
      error -> 
        IO.inspect(error, "GET USER BY NAME")
        {:error, "Please enter a valid User"}
    end
  end

  def create_user(attrs \\ %{}, org) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def update_user(%User{} = user, attrs, org) do
    case Users.is_only_account_owner?(user.id, org) do
      true ->
          with {:ok, _val} <- User.changeset(user, attrs) |> fetch_change( :role_id) do
            changeset = user
            |> User.changeset(attrs)
            |> add_error(:role_id, "There must always be one Account Owner")
            {:error, changeset}
          else
            :error ->
              user
              |> User.changeset(attrs)
              |> Repo.update(prefix: org)
          end
      _    ->
          user
          |> User.changeset(attrs)
          |> Repo.update(prefix: org)
    end
  end

  def is_only_account_owner?(id, org) do
    query =
      from(u in User,
        where: u.role_id == 1,
        select: u.id
      )
    
    case Repo.aggregate(query, :count, :id, prefix: org) do
      n when n == 1 ->
        query
        |> Repo.all(prefix: org)
        |> Enum.member?(id)
      _ -> 
        false
    end
    
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

  def get_role_by_name(name, org) do
    case Repo.get_by(Role, [name: name], prefix: org) do
      nil -> {:error, "No records by this name"}
      {:error, msg} -> {:error, msg}
      role -> {:ok, role}
    end
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

  def create_default_owner_permissions(org) do
    list =
      Users.list_permissions(org)
      |> Enum.map(&create_roles_permissions(%{permission_id: &1.id, role_id: 1}, org))

    {:ok, list}
  end

  def create_default_administrator_permissions(org) do
    list =
      Users.list_permissions(org)
      |> Enum.map(&create_roles_permissions(%{permission_id: &1.id, role_id: 2}, org))

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

  def list_permissions_and_category(org) do
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

  def list_permissions(org) do
    Permission
    |> Repo.all(prefix: org)
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

  def get_roles_permissions(id, org) do
    RolesPermissions
    |> where([rp], rp.role_id == ^id)
    |> Repo.all(prefix: org)
    |> Repo.preload(permission: [:category])
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

  def list_invitations(org) do
    expire_invitations(org)
    Invitation
    |> order_by([i], desc: i.inserted_at)
    |> where([i], i.completed == false)
    |> Repo.all(prefix: org)
    |> Repo.preload(:role)
  end

  def expire_invitations(org) do
    exp_invitations =
      Invitation
      |> where([i], i.expired == false)
      |> Repo.all(prefix: org)
    max_age = Token.get_max_age_minutes()
    exp_invitations
    |> Enum.each(fn i ->
      case Timex.diff(DateTime.utc_now(), i.updated_at, :seconds) do
        diff when diff < max_age -> 
          nil
        _ -> Users.update_invitation(i, %{expired: "true"}, org)
      end
    end)
  end

  def get_invitation!(id, org) do
    Invitation
    |> Repo.get(id, prefix: org)
    |> Repo.preload(:role)
  end

  def get_invitation_by_email(email, org) do
    Invitation
    |> where([i], i.email == ^email)
    |> Repo.one(prefix: org)
  end

  def create_invitation(attrs \\ %{}, org) do
    %Invitation{}
    |> Invitation.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def update_invitation(%Invitation{} = invitation, attrs, org) do
    invitation
    |> Invitation.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def delete_invitation(%Invitation{} = invitation, org) do
    Repo.delete(invitation, prefix: org)
  end

  def change_invitation(%Invitation{} = invitation) do
    Invitation.changeset(invitation, %{})
  end
end
