defmodule Sportegic.NotesTest do
  use Sportegic.DataCase

  alias Sportegic.Notes

  describe "notes" do
    alias Sportegic.Notes.Note

    @valid_attrs %{event_date: ~D[2010-04-17], note: "some note"}
    @update_attrs %{event_date: ~D[2011-05-18], note: "some updated note"}
    @invalid_attrs %{event_date: nil, note: nil}

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notes.create_note()

      note
    end

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Notes.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Notes.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      assert {:ok, %Note{} = note} = Notes.create_note(@valid_attrs)
      assert note.event_date == ~D[2010-04-17]
      assert note.note == "some note"
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = Notes.update_note(note, @update_attrs)
      assert note.event_date == ~D[2011-05-18]
      assert note.note == "some updated note"
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update_note(note, @invalid_attrs)
      assert note == Notes.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Notes.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Notes.change_note(note)
    end
  end

  describe "note_type" do
    alias Sportegic.Notes.NoteType

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def note_type_fixture(attrs \\ %{}) do
      {:ok, note_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notes.create_note_type()

      note_type
    end

    test "list_note_type/0 returns all note_type" do
      note_type = note_type_fixture()
      assert Notes.list_note_type() == [note_type]
    end

    test "get_note_type!/1 returns the note_type with given id" do
      note_type = note_type_fixture()
      assert Notes.get_note_type!(note_type.id) == note_type
    end

    test "create_note_type/1 with valid data creates a note_type" do
      assert {:ok, %NoteType{} = note_type} = Notes.create_note_type(@valid_attrs)
    end

    test "create_note_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create_note_type(@invalid_attrs)
    end

    test "update_note_type/2 with valid data updates the note_type" do
      note_type = note_type_fixture()
      assert {:ok, %NoteType{} = note_type} = Notes.update_note_type(note_type, @update_attrs)
    end

    test "update_note_type/2 with invalid data returns error changeset" do
      note_type = note_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update_note_type(note_type, @invalid_attrs)
      assert note_type == Notes.get_note_type!(note_type.id)
    end

    test "delete_note_type/1 deletes the note_type" do
      note_type = note_type_fixture()
      assert {:ok, %NoteType{}} = Notes.delete_note_type(note_type)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_note_type!(note_type.id) end
    end

    test "change_note_type/1 returns a note_type changeset" do
      note_type = note_type_fixture()
      assert %Ecto.Changeset{} = Notes.change_note_type(note_type)
    end
  end

  describe "notes_people" do
    alias Sportegic.Notes.NotePerson

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def note_person_fixture(attrs \\ %{}) do
      {:ok, note_person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notes.create_note_person()

      note_person
    end

    test "list_notes_people/0 returns all notes_people" do
      note_person = note_person_fixture()
      assert Notes.list_notes_people() == [note_person]
    end

    test "get_note_person!/1 returns the note_person with given id" do
      note_person = note_person_fixture()
      assert Notes.get_note_person!(note_person.id) == note_person
    end

    test "create_note_person/1 with valid data creates a note_person" do
      assert {:ok, %NotePerson{} = note_person} = Notes.create_note_person(@valid_attrs)
    end

    test "create_note_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create_note_person(@invalid_attrs)
    end

    test "update_note_person/2 with valid data updates the note_person" do
      note_person = note_person_fixture()
      assert {:ok, %NotePerson{} = note_person} = Notes.update_note_person(note_person, @update_attrs)
    end

    test "update_note_person/2 with invalid data returns error changeset" do
      note_person = note_person_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update_note_person(note_person, @invalid_attrs)
      assert note_person == Notes.get_note_person!(note_person.id)
    end

    test "delete_note_person/1 deletes the note_person" do
      note_person = note_person_fixture()
      assert {:ok, %NotePerson{}} = Notes.delete_note_person(note_person)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_note_person!(note_person.id) end
    end

    test "change_note_person/1 returns a note_person changeset" do
      note_person = note_person_fixture()
      assert %Ecto.Changeset{} = Notes.change_note_person(note_person)
    end
  end
end
