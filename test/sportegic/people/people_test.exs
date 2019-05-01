defmodule Sportegic.PeopleTest do
  use Sportegic.DataCase

  alias Sportegic.People

  describe "people" do
    alias Sportegic.People.Person

    @valid_attrs %{dob: ~D[2010-04-17], email: "some email", firstname: "some firstname", lastname: "some lastname", middlenames: "some middlenames", mobile: "some mobile", preferred_name: "some preferred_name"}
    @update_attrs %{dob: ~D[2011-05-18], email: "some updated email", firstname: "some updated firstname", lastname: "some updated lastname", middlenames: "some updated middlenames", mobile: "some updated mobile", preferred_name: "some updated preferred_name"}
    @invalid_attrs %{dob: nil, email: nil, firstname: nil, lastname: nil, middlenames: nil, mobile: nil, preferred_name: nil}

    def person_fixture(attrs \\ %{}) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_person()

      person
    end

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert People.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert People.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      assert {:ok, %Person{} = person} = People.create_person(@valid_attrs)
      assert person.dob == ~D[2010-04-17]
      assert person.email == "some email"
      assert person.firstname == "some firstname"
      assert person.lastname == "some lastname"
      assert person.middlenames == "some middlenames"
      assert person.mobile == "some mobile"
      assert person.preferred_name == "some preferred_name"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      assert {:ok, %Person{} = person} = People.update_person(person, @update_attrs)
      assert person.dob == ~D[2011-05-18]
      assert person.email == "some updated email"
      assert person.firstname == "some updated firstname"
      assert person.lastname == "some updated lastname"
      assert person.middlenames == "some updated middlenames"
      assert person.mobile == "some updated mobile"
      assert person.preferred_name == "some updated preferred_name"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_person(person, @invalid_attrs)
      assert person == People.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = People.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> People.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = People.change_person(person)
    end
  end
end
