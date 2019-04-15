defmodule Sportegic.AccountsTest do
  use Sportegic.DataCase

  alias Sportegic.Accounts

  describe "users" do
    alias Sportegic.Accounts.User

    @valid_attrs %{email: "some email"}
    @update_attrs %{email: "some updated email"}
    @invalid_attrs %{email: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "organisations" do
    alias Sportegic.Accounts.Organisation

    @valid_attrs %{display: "some display", name: "some name"}
    @update_attrs %{display: "some updated display", name: "some updated name"}
    @invalid_attrs %{display: nil, name: nil}

    def organisation_fixture(attrs \\ %{}) do
      {:ok, organisation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_organisation()

      organisation
    end

    test "list_organisations/0 returns all organisations" do
      organisation = organisation_fixture()
      assert Accounts.list_organisations() == [organisation]
    end

    test "get_organisation!/1 returns the organisation with given id" do
      organisation = organisation_fixture()
      assert Accounts.get_organisation!(organisation.id) == organisation
    end

    test "create_organisation/1 with valid data creates a organisation" do
      assert {:ok, %Organisation{} = organisation} = Accounts.create_organisation(@valid_attrs)
      assert organisation.display == "some display"
      assert organisation.name == "some name"
    end

    test "create_organisation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organisation(@invalid_attrs)
    end

    test "update_organisation/2 with valid data updates the organisation" do
      organisation = organisation_fixture()
      assert {:ok, %Organisation{} = organisation} = Accounts.update_organisation(organisation, @update_attrs)
      assert organisation.display == "some updated display"
      assert organisation.name == "some updated name"
    end

    test "update_organisation/2 with invalid data returns error changeset" do
      organisation = organisation_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_organisation(organisation, @invalid_attrs)
      assert organisation == Accounts.get_organisation!(organisation.id)
    end

    test "delete_organisation/1 deletes the organisation" do
      organisation = organisation_fixture()
      assert {:ok, %Organisation{}} = Accounts.delete_organisation(organisation)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organisation!(organisation.id) end
    end

    test "change_organisation/1 returns a organisation changeset" do
      organisation = organisation_fixture()
      assert %Ecto.Changeset{} = Accounts.change_organisation(organisation)
    end
  end

  describe "organisations_users" do
    alias Sportegic.Accounts.OrganisationsUsers

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def organisations_users_fixture(attrs \\ %{}) do
      {:ok, organisations_users} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_organisations_users()

      organisations_users
    end

    test "list_organisations_users/0 returns all organisations_users" do
      organisations_users = organisations_users_fixture()
      assert Accounts.list_organisations_users() == [organisations_users]
    end

    test "get_organisations_users!/1 returns the organisations_users with given id" do
      organisations_users = organisations_users_fixture()
      assert Accounts.get_organisations_users!(organisations_users.id) == organisations_users
    end

    test "create_organisations_users/1 with valid data creates a organisations_users" do
      assert {:ok, %OrganisationsUsers{} = organisations_users} = Accounts.create_organisations_users(@valid_attrs)
    end

    test "create_organisations_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organisations_users(@invalid_attrs)
    end

    test "update_organisations_users/2 with valid data updates the organisations_users" do
      organisations_users = organisations_users_fixture()
      assert {:ok, %OrganisationsUsers{} = organisations_users} = Accounts.update_organisations_users(organisations_users, @update_attrs)
    end

    test "update_organisations_users/2 with invalid data returns error changeset" do
      organisations_users = organisations_users_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_organisations_users(organisations_users, @invalid_attrs)
      assert organisations_users == Accounts.get_organisations_users!(organisations_users.id)
    end

    test "delete_organisations_users/1 deletes the organisations_users" do
      organisations_users = organisations_users_fixture()
      assert {:ok, %OrganisationsUsers{}} = Accounts.delete_organisations_users(organisations_users)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organisations_users!(organisations_users.id) end
    end

    test "change_organisations_users/1 returns a organisations_users changeset" do
      organisations_users = organisations_users_fixture()
      assert %Ecto.Changeset{} = Accounts.change_organisations_users(organisations_users)
    end
  end
end
