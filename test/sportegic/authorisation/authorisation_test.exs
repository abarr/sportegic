defmodule Sportegic.AuthorisationTest do
  use Sportegic.DataCase

  alias Sportegic.Authorisation

  describe "permissions" do
    alias Sportegic.Authorisation.Permission

    @valid_attrs %{display: "some display", name: "some name"}
    @update_attrs %{display: "some updated display", name: "some updated name"}
    @invalid_attrs %{display: nil, name: nil}

    def permission_fixture(attrs \\ %{}) do
      {:ok, permission} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authorisation.create_permission()

      permission
    end

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert Authorisation.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert Authorisation.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      assert {:ok, %Permission{} = permission} = Authorisation.create_permission(@valid_attrs)
      assert permission.display == "some display"
      assert permission.name == "some name"
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authorisation.create_permission(@invalid_attrs)
    end

    test "update_permission/2 with valid data updates the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{} = permission} = Authorisation.update_permission(permission, @update_attrs)
      assert permission.display == "some updated display"
      assert permission.name == "some updated name"
    end

    test "update_permission/2 with invalid data returns error changeset" do
      permission = permission_fixture()
      assert {:error, %Ecto.Changeset{}} = Authorisation.update_permission(permission, @invalid_attrs)
      assert permission == Authorisation.get_permission!(permission.id)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = Authorisation.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Authorisation.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = Authorisation.change_permission(permission)
    end
  end

  describe "permissions" do
    alias Sportegic.Authorisation.Premission

    @valid_attrs %{display: "some display", name: "some name"}
    @update_attrs %{display: "some updated display", name: "some updated name"}
    @invalid_attrs %{display: nil, name: nil}

    def premission_fixture(attrs \\ %{}) do
      {:ok, premission} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authorisation.create_premission()

      premission
    end

    test "list_permissions/0 returns all permissions" do
      premission = premission_fixture()
      assert Authorisation.list_permissions() == [premission]
    end

    test "get_premission!/1 returns the premission with given id" do
      premission = premission_fixture()
      assert Authorisation.get_premission!(premission.id) == premission
    end

    test "create_premission/1 with valid data creates a premission" do
      assert {:ok, %Premission{} = premission} = Authorisation.create_premission(@valid_attrs)
      assert premission.display == "some display"
      assert premission.name == "some name"
    end

    test "create_premission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authorisation.create_premission(@invalid_attrs)
    end

    test "update_premission/2 with valid data updates the premission" do
      premission = premission_fixture()
      assert {:ok, %Premission{} = premission} = Authorisation.update_premission(premission, @update_attrs)
      assert premission.display == "some updated display"
      assert premission.name == "some updated name"
    end

    test "update_premission/2 with invalid data returns error changeset" do
      premission = premission_fixture()
      assert {:error, %Ecto.Changeset{}} = Authorisation.update_premission(premission, @invalid_attrs)
      assert premission == Authorisation.get_premission!(premission.id)
    end

    test "delete_premission/1 deletes the premission" do
      premission = premission_fixture()
      assert {:ok, %Premission{}} = Authorisation.delete_premission(premission)
      assert_raise Ecto.NoResultsError, fn -> Authorisation.get_premission!(premission.id) end
    end

    test "change_premission/1 returns a premission changeset" do
      premission = premission_fixture()
      assert %Ecto.Changeset{} = Authorisation.change_premission(premission)
    end
  end

  describe "categories" do
    alias Sportegic.Authorisation.Category

    @valid_attrs %{display: "some display", name: "some name"}
    @update_attrs %{display: "some updated display", name: "some updated name"}
    @invalid_attrs %{display: nil, name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authorisation.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Authorisation.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Authorisation.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Authorisation.create_category(@valid_attrs)
      assert category.display == "some display"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authorisation.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Authorisation.update_category(category, @update_attrs)
      assert category.display == "some updated display"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Authorisation.update_category(category, @invalid_attrs)
      assert category == Authorisation.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Authorisation.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Authorisation.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Authorisation.change_category(category)
    end
  end
end
