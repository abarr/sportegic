defmodule Sportegic.CommunicationsTest do
  use Sportegic.DataCase

  alias Sportegic.Communications

  describe "emails" do
    alias Sportegic.Communications.Email

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def email_fixture(attrs \\ %{}) do
      {:ok, email} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Communications.create_email()

      email
    end

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert Communications.list_emails() == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert Communications.get_email!(email.id) == email
    end

    test "create_email/1 with valid data creates a email" do
      assert {:ok, %Email{} = email} = Communications.create_email(@valid_attrs)
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communications.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      assert {:ok, %Email{} = email} = Communications.update_email(email, @update_attrs)
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = Communications.update_email(email, @invalid_attrs)
      assert email == Communications.get_email!(email.id)
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = Communications.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> Communications.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = Communications.change_email(email)
    end
  end
end
