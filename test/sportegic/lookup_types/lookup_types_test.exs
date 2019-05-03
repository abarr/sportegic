defmodule Sportegic.LookupTypesTest do
  use Sportegic.DataCase

  alias Sportegic.LookupTypes

  describe "lookups" do
    alias Sportegic.LookupTypes.Lookup

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def lookup_fixture(attrs \\ %{}) do
      {:ok, lookup} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LookupTypes.create_lookup()

      lookup
    end

    test "list_lookups/0 returns all lookups" do
      lookup = lookup_fixture()
      assert LookupTypes.list_lookups() == [lookup]
    end

    test "get_lookup!/1 returns the lookup with given id" do
      lookup = lookup_fixture()
      assert LookupTypes.get_lookup!(lookup.id) == lookup
    end

    test "create_lookup/1 with valid data creates a lookup" do
      assert {:ok, %Lookup{} = lookup} = LookupTypes.create_lookup(@valid_attrs)
      assert lookup.name == "some name"
    end

    test "create_lookup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LookupTypes.create_lookup(@invalid_attrs)
    end

    test "update_lookup/2 with valid data updates the lookup" do
      lookup = lookup_fixture()
      assert {:ok, %Lookup{} = lookup} = LookupTypes.update_lookup(lookup, @update_attrs)
      assert lookup.name == "some updated name"
    end

    test "update_lookup/2 with invalid data returns error changeset" do
      lookup = lookup_fixture()
      assert {:error, %Ecto.Changeset{}} = LookupTypes.update_lookup(lookup, @invalid_attrs)
      assert lookup == LookupTypes.get_lookup!(lookup.id)
    end

    test "delete_lookup/1 deletes the lookup" do
      lookup = lookup_fixture()
      assert {:ok, %Lookup{}} = LookupTypes.delete_lookup(lookup)
      assert_raise Ecto.NoResultsError, fn -> LookupTypes.get_lookup!(lookup.id) end
    end

    test "change_lookup/1 returns a lookup changeset" do
      lookup = lookup_fixture()
      assert %Ecto.Changeset{} = LookupTypes.change_lookup(lookup)
    end
  end
end
