defmodule Sportegic.UsersTest do
  use Sportegic.DataCase

  alias Sportegic.Users

  describe "profiles" do
    alias Sportegic.Users.User

    @valid_attrs %{
      complete: true,
      firstname: "some firstname",
      lastname: "some lastname",
      mobile: "some mobile",
      timezone: "some timezone"
    }
    @update_attrs %{
      complete: false,
      firstname: "some updated firstname",
      lastname: "some updated lastname",
      mobile: "some updated mobile",
      timezone: "some updated timezone"
    }
    @invalid_attrs %{complete: nil, firstname: nil, lastname: nil, mobile: nil, timezone: nil}

    def profile_fixture(attrs \\ %{}) do
      {:ok, profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Profiles.create_profile()

      profile
    end

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Profiles.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Profiles.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      assert {:ok, %Profile{} = profile} = Profiles.create_profile(@valid_attrs)
      assert profile.complete == true
      assert profile.firstname == "some firstname"
      assert profile.lastname == "some lastname"
      assert profile.mobile == "some mobile"
      assert profile.timezone == "some timezone"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, @update_attrs)
      assert profile.complete == false
      assert profile.firstname == "some updated firstname"
      assert profile.lastname == "some updated lastname"
      assert profile.mobile == "some updated mobile"
      assert profile.timezone == "some updated timezone"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_profile(profile, @invalid_attrs)
      assert profile == Profiles.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Profiles.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Profiles.change_profile(profile)
    end
  end

  describe "permissions" do
    alias Sportegic.Users.Permission

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def permission_fixture(attrs \\ %{}) do
      {:ok, permission} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Profiles.create_permission()

      permission
    end

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert Profiles.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert Profiles.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      assert {:ok, %Permission{} = permission} = Profiles.create_permission(@valid_attrs)
      assert permission.name == "some name"
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_permission(@invalid_attrs)
    end

    test "update_permission/2 with valid data updates the permission" do
      permission = permission_fixture()

      assert {:ok, %Permission{} = permission} =
               Profiles.update_permission(permission, @update_attrs)

      assert permission.name == "some updated name"
    end

    test "update_permission/2 with invalid data returns error changeset" do
      permission = permission_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_permission(permission, @invalid_attrs)
      assert permission == Profiles.get_permission!(permission.id)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = Profiles.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Users.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = Users.change_permission(permission)
    end
  end

  describe "roles_permissions" do
    alias Sportegic.Users.RolesPermissions

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def roles_permissions_fixture(attrs \\ %{}) do
      {:ok, roles_permissions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Profiles.create_roles_permissions()

      roles_permissions
    end

    test "list_roles_permissions/0 returns all roles_permissions" do
      roles_permissions = roles_permissions_fixture()
      assert Profiles.list_roles_permissions() == [roles_permissions]
    end

    test "get_roles_permissions!/1 returns the roles_permissions with given id" do
      roles_permissions = roles_permissions_fixture()
      assert Profiles.get_roles_permissions!(roles_permissions.id) == roles_permissions
    end

    test "create_roles_permissions/1 with valid data creates a roles_permissions" do
      assert {:ok, %RolesPermissions{} = roles_permissions} =
               Profiles.create_roles_permissions(@valid_attrs)
    end

    test "create_roles_permissions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_roles_permissions(@invalid_attrs)
    end

    test "update_roles_permissions/2 with valid data updates the roles_permissions" do
      roles_permissions = roles_permissions_fixture()

      assert {:ok, %RolesPermissions{} = roles_permissions} =
               Profiles.update_roles_permissions(roles_permissions, @update_attrs)
    end

    test "update_roles_permissions/2 with invalid data returns error changeset" do
      roles_permissions = roles_permissions_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Profiles.update_roles_permissions(roles_permissions, @invalid_attrs)

      assert roles_permissions == Profiles.get_roles_permissions!(roles_permissions.id)
    end

    test "delete_roles_permissions/1 deletes the roles_permissions" do
      roles_permissions = roles_permissions_fixture()
      assert {:ok, %RolesPermissions{}} = Profiles.delete_roles_permissions(roles_permissions)

      assert_raise Ecto.NoResultsError, fn ->
        Profiles.get_roles_permissions!(roles_permissions.id)
      end
    end

    test "change_roles_permissions/1 returns a roles_permissions changeset" do
      roles_permissions = roles_permissions_fixture()
      assert %Ecto.Changeset{} = Profiles.change_roles_permissions(roles_permissions)
    end
  end

  describe "invitations" do
    alias Sportegic.Profiles.Invitation

    @valid_attrs %{email: "some email"}
    @update_attrs %{email: "some updated email"}
    @invalid_attrs %{email: nil}

    def invitation_fixture(attrs \\ %{}) do
      {:ok, invitation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Profiles.create_invitation()

      invitation
    end

    test "list_invitations/0 returns all invitations" do
      invitation = invitation_fixture()
      assert Profiles.list_invitations() == [invitation]
    end

    test "get_invitation!/1 returns the invitation with given id" do
      invitation = invitation_fixture()
      assert Profiles.get_invitation!(invitation.id) == invitation
    end

    test "create_invitation/1 with valid data creates a invitation" do
      assert {:ok, %Invitation{} = invitation} = Profiles.create_invitation(@valid_attrs)
      assert invitation.email == "some email"
    end

    test "create_invitation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_invitation(@invalid_attrs)
    end

    test "update_invitation/2 with valid data updates the invitation" do
      invitation = invitation_fixture()
      assert {:ok, %Invitation{} = invitation} = Profiles.update_invitation(invitation, @update_attrs)
      assert invitation.email == "some updated email"
    end

    test "update_invitation/2 with invalid data returns error changeset" do
      invitation = invitation_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_invitation(invitation, @invalid_attrs)
      assert invitation == Profiles.get_invitation!(invitation.id)
    end

    test "delete_invitation/1 deletes the invitation" do
      invitation = invitation_fixture()
      assert {:ok, %Invitation{}} = Profiles.delete_invitation(invitation)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_invitation!(invitation.id) end
    end

    test "change_invitation/1 returns a invitation changeset" do
      invitation = invitation_fixture()
      assert %Ecto.Changeset{} = Profiles.change_invitation(invitation)
    end
  end
end
