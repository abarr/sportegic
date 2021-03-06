defmodule SportegicWeb.OrganisationControllerTest do
  use SportegicWeb.ConnCase

  alias Sportegic.Accounts

  @create_attrs %{display: "some display", name: "some name"}
  @update_attrs %{display: "some updated display", name: "some updated name"}
  @invalid_attrs %{display: nil, name: nil}

  def fixture(:organisation) do
    {:ok, organisation} = Accounts.create_organisation(@create_attrs)
    organisation
  end

  describe "index" do
    test "lists all organisations", %{conn: conn} do
      conn = get(conn, Routes.organisation_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Organisations"
    end
  end

  describe "new organisation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.organisation_path(conn, :new))
      assert html_response(conn, 200) =~ "New Organisation"
    end
  end

  describe "create organisation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.organisation_path(conn, :create), organisation: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.organisation_path(conn, :show, id)

      conn = get(conn, Routes.organisation_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Organisation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.organisation_path(conn, :create), organisation: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Organisation"
    end
  end

  describe "edit organisation" do
    setup [:create_organisation]

    test "renders form for editing chosen organisation", %{conn: conn, organisation: organisation} do
      conn = get(conn, Routes.organisation_path(conn, :edit, organisation))
      assert html_response(conn, 200) =~ "Edit Organisation"
    end
  end

  describe "update organisation" do
    setup [:create_organisation]

    test "redirects when data is valid", %{conn: conn, organisation: organisation} do
      conn = put(conn, Routes.organisation_path(conn, :update, organisation), organisation: @update_attrs)
      assert redirected_to(conn) == Routes.organisation_path(conn, :show, organisation)

      conn = get(conn, Routes.organisation_path(conn, :show, organisation))
      assert html_response(conn, 200) =~ "some updated display"
    end

    test "renders errors when data is invalid", %{conn: conn, organisation: organisation} do
      conn = put(conn, Routes.organisation_path(conn, :update, organisation), organisation: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Organisation"
    end
  end

  describe "delete organisation" do
    setup [:create_organisation]

    test "deletes chosen organisation", %{conn: conn, organisation: organisation} do
      conn = delete(conn, Routes.organisation_path(conn, :delete, organisation))
      assert redirected_to(conn) == Routes.organisation_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.organisation_path(conn, :show, organisation))
      end
    end
  end

  defp create_organisation(_) do
    organisation = fixture(:organisation)
    {:ok, organisation: organisation}
  end
end
