defmodule Sportegic.PeopleTest do
  use Sportegic.DataCase

  alias Sportegic.People

  describe "athletic_profiles" do
    alias Sportegic.People.AthleticProfile

    @valid_attrs %{available: true}
    @update_attrs %{available: false}
    @invalid_attrs %{available: nil}

    def athletic_profile_fixture(attrs \\ %{}) do
      {:ok, athletic_profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_athletic_profile()

      athletic_profile
    end

    test "list_athletic_profiles/0 returns all athletic_profiles" do
      athletic_profile = athletic_profile_fixture()
      assert People.list_athletic_profiles() == [athletic_profile]
    end

    test "get_athletic_profile!/1 returns the athletic_profile with given id" do
      athletic_profile = athletic_profile_fixture()
      assert People.get_athletic_profile!(athletic_profile.id) == athletic_profile
    end

    test "create_athletic_profile/1 with valid data creates a athletic_profile" do
      assert {:ok, %AthleticProfile{} = athletic_profile} = People.create_athletic_profile(@valid_attrs)
      assert athletic_profile.available == true
    end

    test "create_athletic_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_athletic_profile(@invalid_attrs)
    end

    test "update_athletic_profile/2 with valid data updates the athletic_profile" do
      athletic_profile = athletic_profile_fixture()
      assert {:ok, %AthleticProfile{} = athletic_profile} = People.update_athletic_profile(athletic_profile, @update_attrs)
      assert athletic_profile.available == false
    end

    test "update_athletic_profile/2 with invalid data returns error changeset" do
      athletic_profile = athletic_profile_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_athletic_profile(athletic_profile, @invalid_attrs)
      assert athletic_profile == People.get_athletic_profile!(athletic_profile.id)
    end

    test "delete_athletic_profile/1 deletes the athletic_profile" do
      athletic_profile = athletic_profile_fixture()
      assert {:ok, %AthleticProfile{}} = People.delete_athletic_profile(athletic_profile)
      assert_raise Ecto.NoResultsError, fn -> People.get_athletic_profile!(athletic_profile.id) end
    end

    test "change_athletic_profile/1 returns a athletic_profile changeset" do
      athletic_profile = athletic_profile_fixture()
      assert %Ecto.Changeset{} = People.change_athletic_profile(athletic_profile)
    end
  end

  describe "athlete_positions" do
    alias Sportegic.People.AthletePosition

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def athlete_position_fixture(attrs \\ %{}) do
      {:ok, athlete_position} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_athlete_position()

      athlete_position
    end

    test "list_athlete_positions/0 returns all athlete_positions" do
      athlete_position = athlete_position_fixture()
      assert People.list_athlete_positions() == [athlete_position]
    end

    test "get_athlete_position!/1 returns the athlete_position with given id" do
      athlete_position = athlete_position_fixture()
      assert People.get_athlete_position!(athlete_position.id) == athlete_position
    end

    test "create_athlete_position/1 with valid data creates a athlete_position" do
      assert {:ok, %AthletePosition{} = athlete_position} = People.create_athlete_position(@valid_attrs)
    end

    test "create_athlete_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_athlete_position(@invalid_attrs)
    end

    test "update_athlete_position/2 with valid data updates the athlete_position" do
      athlete_position = athlete_position_fixture()
      assert {:ok, %AthletePosition{} = athlete_position} = People.update_athlete_position(athlete_position, @update_attrs)
    end

    test "update_athlete_position/2 with invalid data returns error changeset" do
      athlete_position = athlete_position_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_athlete_position(athlete_position, @invalid_attrs)
      assert athlete_position == People.get_athlete_position!(athlete_position.id)
    end

    test "delete_athlete_position/1 deletes the athlete_position" do
      athlete_position = athlete_position_fixture()
      assert {:ok, %AthletePosition{}} = People.delete_athlete_position(athlete_position)
      assert_raise Ecto.NoResultsError, fn -> People.get_athlete_position!(athlete_position.id) end
    end

    test "change_athlete_position/1 returns a athlete_position changeset" do
      athlete_position = athlete_position_fixture()
      assert %Ecto.Changeset{} = People.change_athlete_position(athlete_position)
    end
  end
end
