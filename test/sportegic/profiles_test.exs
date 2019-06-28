defmodule Sportegic.ProfilesTest do
  use Sportegic.DataCase

  alias Sportegic.Profiles

  describe "performances" do
    alias Sportegic.Profiles.Performance

    @valid_attrs %{review: "some review"}
    @update_attrs %{review: "some updated review"}
    @invalid_attrs %{review: nil}

    def performance_fixture(attrs \\ %{}) do
      {:ok, performance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Profiles.create_performance()

      performance
    end

    test "list_performances/0 returns all performances" do
      performance = performance_fixture()
      assert Profiles.list_performances() == [performance]
    end

    test "get_performance!/1 returns the performance with given id" do
      performance = performance_fixture()
      assert Profiles.get_performance!(performance.id) == performance
    end

    test "create_performance/1 with valid data creates a performance" do
      assert {:ok, %Performance{} = performance} = Profiles.create_performance(@valid_attrs)
      assert performance.review == "some review"
    end

    test "create_performance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_performance(@invalid_attrs)
    end

    test "update_performance/2 with valid data updates the performance" do
      performance = performance_fixture()
      assert {:ok, %Performance{} = performance} = Profiles.update_performance(performance, @update_attrs)
      assert performance.review == "some updated review"
    end

    test "update_performance/2 with invalid data returns error changeset" do
      performance = performance_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_performance(performance, @invalid_attrs)
      assert performance == Profiles.get_performance!(performance.id)
    end

    test "delete_performance/1 deletes the performance" do
      performance = performance_fixture()
      assert {:ok, %Performance{}} = Profiles.delete_performance(performance)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_performance!(performance.id) end
    end

    test "change_performance/1 returns a performance changeset" do
      performance = performance_fixture()
      assert %Ecto.Changeset{} = Profiles.change_performance(performance)
    end
  end
end
