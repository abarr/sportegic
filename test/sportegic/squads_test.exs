defmodule Sportegic.SquadsTest do
  use Sportegic.DataCase

  alias Sportegic.Squads

  describe "squads" do
    alias Sportegic.Squads.Squad

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def squad_fixture(attrs \\ %{}) do
      {:ok, squad} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Squads.create_squad()

      squad
    end

    test "list_squads/0 returns all squads" do
      squad = squad_fixture()
      assert Squads.list_squads() == [squad]
    end

    test "get_squad!/1 returns the squad with given id" do
      squad = squad_fixture()
      assert Squads.get_squad!(squad.id) == squad
    end

    test "create_squad/1 with valid data creates a squad" do
      assert {:ok, %Squad{} = squad} = Squads.create_squad(@valid_attrs)
      assert squad.name == "some name"
    end

    test "create_squad/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Squads.create_squad(@invalid_attrs)
    end

    test "update_squad/2 with valid data updates the squad" do
      squad = squad_fixture()
      assert {:ok, %Squad{} = squad} = Squads.update_squad(squad, @update_attrs)
      assert squad.name == "some updated name"
    end

    test "update_squad/2 with invalid data returns error changeset" do
      squad = squad_fixture()
      assert {:error, %Ecto.Changeset{}} = Squads.update_squad(squad, @invalid_attrs)
      assert squad == Squads.get_squad!(squad.id)
    end

    test "delete_squad/1 deletes the squad" do
      squad = squad_fixture()
      assert {:ok, %Squad{}} = Squads.delete_squad(squad)
      assert_raise Ecto.NoResultsError, fn -> Squads.get_squad!(squad.id) end
    end

    test "change_squad/1 returns a squad changeset" do
      squad = squad_fixture()
      assert %Ecto.Changeset{} = Squads.change_squad(squad)
    end
  end
end
