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
end
