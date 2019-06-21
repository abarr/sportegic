defmodule Sportegic.NotesTest do
  use Sportegic.DataCase

  alias Sportegic.Notes

  describe "comments" do
    alias Sportegic.Notes.Comment

    @valid_attrs %{details: "some details"}
    @update_attrs %{details: "some updated details"}
    @invalid_attrs %{details: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notes.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Notes.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Notes.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Notes.create_comment(@valid_attrs)
      assert comment.details == "some details"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Notes.update_comment(comment, @update_attrs)
      assert comment.details == "some updated details"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update_comment(comment, @invalid_attrs)
      assert comment == Notes.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Notes.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Notes.change_comment(comment)
    end
  end

  describe "squads_peoiple" do
    alias Sportegic.Notes.SquadPerson

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def squad_person_fixture(attrs \\ %{}) do
      {:ok, squad_person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notes.create_squad_person()

      squad_person
    end

    test "list_squads_peoiple/0 returns all squads_peoiple" do
      squad_person = squad_person_fixture()
      assert Notes.list_squads_peoiple() == [squad_person]
    end

    test "get_squad_person!/1 returns the squad_person with given id" do
      squad_person = squad_person_fixture()
      assert Notes.get_squad_person!(squad_person.id) == squad_person
    end

    test "create_squad_person/1 with valid data creates a squad_person" do
      assert {:ok, %SquadPerson{} = squad_person} = Notes.create_squad_person(@valid_attrs)
    end

    test "create_squad_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create_squad_person(@invalid_attrs)
    end

    test "update_squad_person/2 with valid data updates the squad_person" do
      squad_person = squad_person_fixture()
      assert {:ok, %SquadPerson{} = squad_person} = Notes.update_squad_person(squad_person, @update_attrs)
    end

    test "update_squad_person/2 with invalid data returns error changeset" do
      squad_person = squad_person_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update_squad_person(squad_person, @invalid_attrs)
      assert squad_person == Notes.get_squad_person!(squad_person.id)
    end

    test "delete_squad_person/1 deletes the squad_person" do
      squad_person = squad_person_fixture()
      assert {:ok, %SquadPerson{}} = Notes.delete_squad_person(squad_person)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_squad_person!(squad_person.id) end
    end

    test "change_squad_person/1 returns a squad_person changeset" do
      squad_person = squad_person_fixture()
      assert %Ecto.Changeset{} = Notes.change_squad_person(squad_person)
    end
  end
end
