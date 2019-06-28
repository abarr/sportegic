defmodule SportegicWeb.PerformanceControllerTest do
  use SportegicWeb.ConnCase

  alias Sportegic.Profiles

  @create_attrs %{review: "some review"}
  @update_attrs %{review: "some updated review"}
  @invalid_attrs %{review: nil}

  def fixture(:performance) do
    {:ok, performance} = Profiles.create_performance(@create_attrs)
    performance
  end

  describe "index" do
    test "lists all performances", %{conn: conn} do
      conn = get(conn, Routes.performance_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Performances"
    end
  end

  describe "new performance" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.performance_path(conn, :new))
      assert html_response(conn, 200) =~ "New Performance"
    end
  end

  describe "create performance" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.performance_path(conn, :create), performance: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.performance_path(conn, :show, id)

      conn = get(conn, Routes.performance_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Performance"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.performance_path(conn, :create), performance: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Performance"
    end
  end

  describe "edit performance" do
    setup [:create_performance]

    test "renders form for editing chosen performance", %{conn: conn, performance: performance} do
      conn = get(conn, Routes.performance_path(conn, :edit, performance))
      assert html_response(conn, 200) =~ "Edit Performance"
    end
  end

  describe "update performance" do
    setup [:create_performance]

    test "redirects when data is valid", %{conn: conn, performance: performance} do
      conn = put(conn, Routes.performance_path(conn, :update, performance), performance: @update_attrs)
      assert redirected_to(conn) == Routes.performance_path(conn, :show, performance)

      conn = get(conn, Routes.performance_path(conn, :show, performance))
      assert html_response(conn, 200) =~ "some updated review"
    end

    test "renders errors when data is invalid", %{conn: conn, performance: performance} do
      conn = put(conn, Routes.performance_path(conn, :update, performance), performance: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Performance"
    end
  end

  describe "delete performance" do
    setup [:create_performance]

    test "deletes chosen performance", %{conn: conn, performance: performance} do
      conn = delete(conn, Routes.performance_path(conn, :delete, performance))
      assert redirected_to(conn) == Routes.performance_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.performance_path(conn, :show, performance))
      end
    end
  end

  defp create_performance(_) do
    performance = fixture(:performance)
    {:ok, performance: performance}
  end
end
