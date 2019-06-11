defmodule Sportegic.AddressesTest do
  use Sportegic.DataCase

  alias Sportegic.Addresses

  describe "addresses" do
    alias Sportegic.Addresses.Address

    @valid_attrs %{address: "some address", administrative_area_level_1: "some administrative_area_level_1", country: "some country", locality: "some locality", postal_code: "some postal_code", route: "some route", street_number: "some street_number", unit_number: "some unit_number"}
    @update_attrs %{address: "some updated address", administrative_area_level_1: "some updated administrative_area_level_1", country: "some updated country", locality: "some updated locality", postal_code: "some updated postal_code", route: "some updated route", street_number: "some updated street_number", unit_number: "some updated unit_number"}
    @invalid_attrs %{address: nil, administrative_area_level_1: nil, country: nil, locality: nil, postal_code: nil, route: nil, street_number: nil, unit_number: nil}

    def address_fixture(attrs \\ %{}) do
      {:ok, address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Addresses.create_address()

      address
    end

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Addresses.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Addresses.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      assert {:ok, %Address{} = address} = Addresses.create_address(@valid_attrs)
      assert address.address == "some address"
      assert address.administrative_area_level_1 == "some administrative_area_level_1"
      assert address.country == "some country"
      assert address.locality == "some locality"
      assert address.postal_code == "some postal_code"
      assert address.route == "some route"
      assert address.street_number == "some street_number"
      assert address.unit_number == "some unit_number"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Addresses.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      assert {:ok, %Address{} = address} = Addresses.update_address(address, @update_attrs)
      assert address.address == "some updated address"
      assert address.administrative_area_level_1 == "some updated administrative_area_level_1"
      assert address.country == "some updated country"
      assert address.locality == "some updated locality"
      assert address.postal_code == "some updated postal_code"
      assert address.route == "some updated route"
      assert address.street_number == "some updated street_number"
      assert address.unit_number == "some updated unit_number"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Addresses.update_address(address, @invalid_attrs)
      assert address == Addresses.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Addresses.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Addresses.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Addresses.change_address(address)
    end
  end
end
