defmodule SportegicWeb.ProfileControllerTest do
  use SportegicWeb.ConnCase

  alias Sportegic.Users

  @create_attrs %{
    complete: true,
    firstname: "some firstname",
    lastname: "some lastname",
    mobile: "some mobile",
    timezone: "some timezone"
  }
  @update_attrs %{
    complete: false,
    firstname: "some updated firstname",
    lastname: "some updated lastname",
    mobile: "some updated mobile",
    timezone: "some updated timezone"
  }
  @invalid_attrs %{complete: nil, firstname: nil, lastname: nil, mobile: nil, timezone: nil}

  def fixture(:profile) do
    {:ok, profile} = Profiles.create_profile(@create_attrs)
    profile
  end

  describe "index" do
    test "lists all profiles", %{conn: conn} do
      conn = get(conn, Routes.profile_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Profiles"
    end
  end

  describe "new profile" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.profile_path(conn, :new))
      assert html_response(conn, 200) =~ "New Profile"
    end
  end

  describe "create profile" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.profile_path(conn, :create), profile: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.profile_path(conn, :show, id)

      conn = get(conn, Routes.profile_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Profile"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.profile_path(conn, :create), profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Profile"
    end
  end

  describe "edit profile" do
    setup [:create_profile]

    test "renders form for editing chosen profile", %{conn: conn, profile: profile} do
      conn = get(conn, Routes.profile_path(conn, :edit, profile))
      assert html_response(conn, 200) =~ "Edit Profile"
    end
  end

  describe "update profile" do
    setup [:create_profile]

    test "redirects when data is valid", %{conn: conn, profile: profile} do
      conn = put(conn, Routes.profile_path(conn, :update, profile), profile: @update_attrs)
      assert redirected_to(conn) == Routes.profile_path(conn, :show, profile)

      conn = get(conn, Routes.profile_path(conn, :show, profile))
      assert html_response(conn, 200) =~ "some updated firstname"
    end

    test "renders errors when data is invalid", %{conn: conn, profile: profile} do
      conn = put(conn, Routes.profile_path(conn, :update, profile), profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Profile"
    end
  end

  describe "delete profile" do
    setup [:create_profile]

    test "deletes chosen profile", %{conn: conn, profile: profile} do
      conn = delete(conn, Routes.profile_path(conn, :delete, profile))
      assert redirected_to(conn) == Routes.profile_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.profile_path(conn, :show, profile))
      end
    end
  end

  defp create_profile(_) do
    profile = fixture(:profile)
    {:ok, profile: profile}
  end
end
