defmodule SportegicWeb.ProfileControllerTest do
  use SportegicWeb.ConnCase

  alias Sportegic.People

  @create_attrs %{available: true}
  @update_attrs %{available: false}
  @invalid_attrs %{available: nil}

  def fixture(:athletic_profile) do
    {:ok, athletic_profile} = People.create_athletic_profile(@create_attrs)
    athletic_profile
  end

  describe "index" do
    test "lists all athletic_profiles", %{conn: conn} do
      conn = get(conn, Routes.athletic_profile_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Athletic profiles"
    end
  end

  describe "new athletic_profile" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.athletic_profile_path(conn, :new))
      assert html_response(conn, 200) =~ "New Athletic profile"
    end
  end

  describe "create athletic_profile" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.athletic_profile_path(conn, :create), athletic_profile: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.athletic_profile_path(conn, :show, id)

      conn = get(conn, Routes.athletic_profile_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Athletic profile"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.athletic_profile_path(conn, :create), athletic_profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Athletic profile"
    end
  end

  describe "edit athletic_profile" do
    setup [:create_athletic_profile]

    test "renders form for editing chosen athletic_profile", %{conn: conn, athletic_profile: athletic_profile} do
      conn = get(conn, Routes.athletic_profile_path(conn, :edit, athletic_profile))
      assert html_response(conn, 200) =~ "Edit Athletic profile"
    end
  end

  describe "update athletic_profile" do
    setup [:create_athletic_profile]

    test "redirects when data is valid", %{conn: conn, athletic_profile: athletic_profile} do
      conn = put(conn, Routes.athletic_profile_path(conn, :update, athletic_profile), athletic_profile: @update_attrs)
      assert redirected_to(conn) == Routes.athletic_profile_path(conn, :show, athletic_profile)

      conn = get(conn, Routes.athletic_profile_path(conn, :show, athletic_profile))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, athletic_profile: athletic_profile} do
      conn = put(conn, Routes.athletic_profile_path(conn, :update, athletic_profile), athletic_profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Athletic profile"
    end
  end

  describe "delete athletic_profile" do
    setup [:create_athletic_profile]

    test "deletes chosen athletic_profile", %{conn: conn, athletic_profile: athletic_profile} do
      conn = delete(conn, Routes.athletic_profile_path(conn, :delete, athletic_profile))
      assert redirected_to(conn) == Routes.athletic_profile_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.athletic_profile_path(conn, :show, athletic_profile))
      end
    end
  end

  defp create_athletic_profile(_) do
    athletic_profile = fixture(:athletic_profile)
    {:ok, athletic_profile: athletic_profile}
  end
end
