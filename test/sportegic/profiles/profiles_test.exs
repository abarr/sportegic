defmodule Sportegic.ProfilesTest do
  use Sportegic.DataCase

  alias Sportegic.Profiles

  describe "profiles" do
    alias Sportegic.Profiles.Profile

    @valid_attrs %{complete: true, firstname: "some firstname", lastname: "some lastname", mobile: "some mobile", timezone: "some timezone"}
    @update_attrs %{complete: false, firstname: "some updated firstname", lastname: "some updated lastname", mobile: "some updated mobile", timezone: "some updated timezone"}
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
    alias Sportegic.Profiles.Permission

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
      assert {:ok, %Permission{} = permission} = Profiles.update_permission(permission, @update_attrs)
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
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = Profiles.change_permission(permission)
    end
  end
end
