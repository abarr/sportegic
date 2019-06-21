defmodule SportegicWeb.SquadControllerTest do
  use SportegicWeb.ConnCase

  alias Sportegic.Squads

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:squad) do
    {:ok, squad} = Squads.create_squad(@create_attrs)
    squad
  end

  describe "index" do
    test "lists all squads", %{conn: conn} do
      conn = get(conn, Routes.squad_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Squads"
    end
  end

  describe "new squad" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.squad_path(conn, :new))
      assert html_response(conn, 200) =~ "New Squad"
    end
  end

  describe "create squad" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.squad_path(conn, :create), squad: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.squad_path(conn, :show, id)

      conn = get(conn, Routes.squad_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Squad"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.squad_path(conn, :create), squad: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Squad"
    end
  end

  describe "edit squad" do
    setup [:create_squad]

    test "renders form for editing chosen squad", %{conn: conn, squad: squad} do
      conn = get(conn, Routes.squad_path(conn, :edit, squad))
      assert html_response(conn, 200) =~ "Edit Squad"
    end
  end

  describe "update squad" do
    setup [:create_squad]

    test "redirects when data is valid", %{conn: conn, squad: squad} do
      conn = put(conn, Routes.squad_path(conn, :update, squad), squad: @update_attrs)
      assert redirected_to(conn) == Routes.squad_path(conn, :show, squad)

      conn = get(conn, Routes.squad_path(conn, :show, squad))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, squad: squad} do
      conn = put(conn, Routes.squad_path(conn, :update, squad), squad: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Squad"
    end
  end

  describe "delete squad" do
    setup [:create_squad]

    test "deletes chosen squad", %{conn: conn, squad: squad} do
      conn = delete(conn, Routes.squad_path(conn, :delete, squad))
      assert redirected_to(conn) == Routes.squad_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.squad_path(conn, :show, squad))
      end
    end
  end

  defp create_squad(_) do
    squad = fixture(:squad)
    {:ok, squad: squad}
  end
end
