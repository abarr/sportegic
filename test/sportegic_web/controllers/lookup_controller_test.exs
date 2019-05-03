defmodule SportegicWeb.LookupControllerTest do
  use SportegicWeb.ConnCase

  alias Sportegic.LookupTypes

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:lookup) do
    {:ok, lookup} = LookupTypes.create_lookup(@create_attrs)
    lookup
  end

  describe "index" do
    test "lists all lookups", %{conn: conn} do
      conn = get(conn, Routes.lookup_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Lookups"
    end
  end

  describe "new lookup" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.lookup_path(conn, :new))
      assert html_response(conn, 200) =~ "New Lookup"
    end
  end

  describe "create lookup" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.lookup_path(conn, :create), lookup: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.lookup_path(conn, :show, id)

      conn = get(conn, Routes.lookup_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Lookup"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.lookup_path(conn, :create), lookup: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Lookup"
    end
  end

  describe "edit lookup" do
    setup [:create_lookup]

    test "renders form for editing chosen lookup", %{conn: conn, lookup: lookup} do
      conn = get(conn, Routes.lookup_path(conn, :edit, lookup))
      assert html_response(conn, 200) =~ "Edit Lookup"
    end
  end

  describe "update lookup" do
    setup [:create_lookup]

    test "redirects when data is valid", %{conn: conn, lookup: lookup} do
      conn = put(conn, Routes.lookup_path(conn, :update, lookup), lookup: @update_attrs)
      assert redirected_to(conn) == Routes.lookup_path(conn, :show, lookup)

      conn = get(conn, Routes.lookup_path(conn, :show, lookup))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, lookup: lookup} do
      conn = put(conn, Routes.lookup_path(conn, :update, lookup), lookup: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Lookup"
    end
  end

  describe "delete lookup" do
    setup [:create_lookup]

    test "deletes chosen lookup", %{conn: conn, lookup: lookup} do
      conn = delete(conn, Routes.lookup_path(conn, :delete, lookup))
      assert redirected_to(conn) == Routes.lookup_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.lookup_path(conn, :show, lookup))
      end
    end
  end

  defp create_lookup(_) do
    lookup = fixture(:lookup)
    {:ok, lookup: lookup}
  end
end
