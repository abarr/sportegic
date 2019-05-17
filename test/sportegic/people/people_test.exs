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

  describe "visas" do
    alias Sportegic.People.Visa

    @valid_attrs %{additional_info: "some additional_info", expiry_date: ~D[2010-04-17], issued_date: ~D[2010-04-17], issuer: "some issuer", number: "some number"}
    @update_attrs %{additional_info: "some updated additional_info", expiry_date: ~D[2011-05-18], issued_date: ~D[2011-05-18], issuer: "some updated issuer", number: "some updated number"}
    @invalid_attrs %{additional_info: nil, expiry_date: nil, issued_date: nil, issuer: nil, number: nil}

    def visa_fixture(attrs \\ %{}) do
      {:ok, visa} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_visa()

      visa
    end

    test "list_visas/0 returns all visas" do
      visa = visa_fixture()
      assert People.list_visas() == [visa]
    end

    test "get_visa!/1 returns the visa with given id" do
      visa = visa_fixture()
      assert People.get_visa!(visa.id) == visa
    end

    test "create_visa/1 with valid data creates a visa" do
      assert {:ok, %Visa{} = visa} = People.create_visa(@valid_attrs)
      assert visa.additional_info == "some additional_info"
      assert visa.expiry_date == ~D[2010-04-17]
      assert visa.issued_date == ~D[2010-04-17]
      assert visa.issuer == "some issuer"
      assert visa.number == "some number"
    end

    test "create_visa/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_visa(@invalid_attrs)
    end

    test "update_visa/2 with valid data updates the visa" do
      visa = visa_fixture()
      assert {:ok, %Visa{} = visa} = People.update_visa(visa, @update_attrs)
      assert visa.additional_info == "some updated additional_info"
      assert visa.expiry_date == ~D[2011-05-18]
      assert visa.issued_date == ~D[2011-05-18]
      assert visa.issuer == "some updated issuer"
      assert visa.number == "some updated number"
    end

    test "update_visa/2 with invalid data returns error changeset" do
      visa = visa_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_visa(visa, @invalid_attrs)
      assert visa == People.get_visa!(visa.id)
    end

    test "delete_visa/1 deletes the visa" do
      visa = visa_fixture()
      assert {:ok, %Visa{}} = People.delete_visa(visa)
      assert_raise Ecto.NoResultsError, fn -> People.get_visa!(visa.id) end
    end

    test "change_visa/1 returns a visa changeset" do
      visa = visa_fixture()
      assert %Ecto.Changeset{} = People.change_visa(visa)
    end
  end

  describe "insurance_policies" do
    alias Sportegic.People.InsurancePolicy

    @valid_attrs %{additional_info: "some additional_info", coverage_amount: 42, expiry_date: ~D[2010-04-17], issuer: "some issuer", number: "some number"}
    @update_attrs %{additional_info: "some updated additional_info", coverage_amount: 43, expiry_date: ~D[2011-05-18], issuer: "some updated issuer", number: "some updated number"}
    @invalid_attrs %{additional_info: nil, coverage_amount: nil, expiry_date: nil, issuer: nil, number: nil}

    def insurance_policy_fixture(attrs \\ %{}) do
      {:ok, insurance_policy} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_insurance_policy()

      insurance_policy
    end

    test "list_insurance_policies/0 returns all insurance_policies" do
      insurance_policy = insurance_policy_fixture()
      assert People.list_insurance_policies() == [insurance_policy]
    end

    test "get_insurance_policy!/1 returns the insurance_policy with given id" do
      insurance_policy = insurance_policy_fixture()
      assert People.get_insurance_policy!(insurance_policy.id) == insurance_policy
    end

    test "create_insurance_policy/1 with valid data creates a insurance_policy" do
      assert {:ok, %InsurancePolicy{} = insurance_policy} = People.create_insurance_policy(@valid_attrs)
      assert insurance_policy.additional_info == "some additional_info"
      assert insurance_policy.coverage_amount == 42
      assert insurance_policy.expiry_date == ~D[2010-04-17]
      assert insurance_policy.issuer == "some issuer"
      assert insurance_policy.number == "some number"
    end

    test "create_insurance_policy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_insurance_policy(@invalid_attrs)
    end

    test "update_insurance_policy/2 with valid data updates the insurance_policy" do
      insurance_policy = insurance_policy_fixture()
      assert {:ok, %InsurancePolicy{} = insurance_policy} = People.update_insurance_policy(insurance_policy, @update_attrs)
      assert insurance_policy.additional_info == "some updated additional_info"
      assert insurance_policy.coverage_amount == 43
      assert insurance_policy.expiry_date == ~D[2011-05-18]
      assert insurance_policy.issuer == "some updated issuer"
      assert insurance_policy.number == "some updated number"
    end

    test "update_insurance_policy/2 with invalid data returns error changeset" do
      insurance_policy = insurance_policy_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_insurance_policy(insurance_policy, @invalid_attrs)
      assert insurance_policy == People.get_insurance_policy!(insurance_policy.id)
    end

    test "delete_insurance_policy/1 deletes the insurance_policy" do
      insurance_policy = insurance_policy_fixture()
      assert {:ok, %InsurancePolicy{}} = People.delete_insurance_policy(insurance_policy)
      assert_raise Ecto.NoResultsError, fn -> People.get_insurance_policy!(insurance_policy.id) end
    end

    test "change_insurance_policy/1 returns a insurance_policy changeset" do
      insurance_policy = insurance_policy_fixture()
      assert %Ecto.Changeset{} = People.change_insurance_policy(insurance_policy)
    end
  end
end
