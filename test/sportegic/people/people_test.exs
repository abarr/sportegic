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

  describe "documents" do
    alias Sportegic.People.Document

    @valid_attrs %{additional_info: "some additional_info", expiry_date: ~D[2010-04-17], file: "some file", issuer: "some issuer", number: "some number"}
    @update_attrs %{additional_info: "some updated additional_info", expiry_date: ~D[2011-05-18], file: "some updated file", issuer: "some updated issuer", number: "some updated number"}
    @invalid_attrs %{additional_info: nil, expiry_date: nil, file: nil, issuer: nil, number: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_document()

      document
    end

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert People.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert People.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = People.create_document(@valid_attrs)
      assert document.additional_info == "some additional_info"
      assert document.expiry_date == ~D[2010-04-17]
      assert document.file == "some file"
      assert document.issuer == "some issuer"
      assert document.number == "some number"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, %Document{} = document} = People.update_document(document, @update_attrs)
      assert document.additional_info == "some updated additional_info"
      assert document.expiry_date == ~D[2011-05-18]
      assert document.file == "some updated file"
      assert document.issuer == "some updated issuer"
      assert document.number == "some updated number"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_document(document, @invalid_attrs)
      assert document == People.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = People.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> People.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = People.change_document(document)
    end
  end

  describe "attachments" do
    alias Sportegic.People.Attachment

    @valid_attrs %{file: "some file"}
    @update_attrs %{file: "some updated file"}
    @invalid_attrs %{file: nil}

    def attachment_fixture(attrs \\ %{}) do
      {:ok, attachment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_attachment()

      attachment
    end

    test "list_attachments/0 returns all attachments" do
      attachment = attachment_fixture()
      assert People.list_attachments() == [attachment]
    end

    test "get_attachment!/1 returns the attachment with given id" do
      attachment = attachment_fixture()
      assert People.get_attachment!(attachment.id) == attachment
    end

    test "create_attachment/1 with valid data creates a attachment" do
      assert {:ok, %Attachment{} = attachment} = People.create_attachment(@valid_attrs)
      assert attachment.file == "some file"
    end

    test "create_attachment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_attachment(@invalid_attrs)
    end

    test "update_attachment/2 with valid data updates the attachment" do
      attachment = attachment_fixture()
      assert {:ok, %Attachment{} = attachment} = People.update_attachment(attachment, @update_attrs)
      assert attachment.file == "some updated file"
    end

    test "update_attachment/2 with invalid data returns error changeset" do
      attachment = attachment_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_attachment(attachment, @invalid_attrs)
      assert attachment == People.get_attachment!(attachment.id)
    end

    test "delete_attachment/1 deletes the attachment" do
      attachment = attachment_fixture()
      assert {:ok, %Attachment{}} = People.delete_attachment(attachment)
      assert_raise Ecto.NoResultsError, fn -> People.get_attachment!(attachment.id) end
    end

    test "change_attachment/1 returns a attachment changeset" do
      attachment = attachment_fixture()
      assert %Ecto.Changeset{} = People.change_attachment(attachment)
    end
  end
end
