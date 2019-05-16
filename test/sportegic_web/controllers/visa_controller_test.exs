defmodule SportegicWeb.VisaControllerTest do
  use SportegicWeb.ConnCase

  alias Sportegic.People

  @create_attrs %{additional_info: "some additional_info", expiry_date: ~D[2010-04-17], issued_date: ~D[2010-04-17], issuer: "some issuer", number: "some number"}
  @update_attrs %{additional_info: "some updated additional_info", expiry_date: ~D[2011-05-18], issued_date: ~D[2011-05-18], issuer: "some updated issuer", number: "some updated number"}
  @invalid_attrs %{additional_info: nil, expiry_date: nil, issued_date: nil, issuer: nil, number: nil}

  def fixture(:visa) do
    {:ok, visa} = People.create_visa(@create_attrs)
    visa
  end

  describe "index" do
    test "lists all visas", %{conn: conn} do
      conn = get(conn, Routes.visa_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Visas"
    end
  end

  describe "new visa" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.visa_path(conn, :new))
      assert html_response(conn, 200) =~ "New Visa"
    end
  end

  describe "create visa" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.visa_path(conn, :create), visa: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.visa_path(conn, :show, id)

      conn = get(conn, Routes.visa_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Visa"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.visa_path(conn, :create), visa: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Visa"
    end
  end

  describe "edit visa" do
    setup [:create_visa]

    test "renders form for editing chosen visa", %{conn: conn, visa: visa} do
      conn = get(conn, Routes.visa_path(conn, :edit, visa))
      assert html_response(conn, 200) =~ "Edit Visa"
    end
  end

  describe "update visa" do
    setup [:create_visa]

    test "redirects when data is valid", %{conn: conn, visa: visa} do
      conn = put(conn, Routes.visa_path(conn, :update, visa), visa: @update_attrs)
      assert redirected_to(conn) == Routes.visa_path(conn, :show, visa)

      conn = get(conn, Routes.visa_path(conn, :show, visa))
      assert html_response(conn, 200) =~ "some updated additional_info"
    end

    test "renders errors when data is invalid", %{conn: conn, visa: visa} do
      conn = put(conn, Routes.visa_path(conn, :update, visa), visa: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Visa"
    end
  end

  describe "delete visa" do
    setup [:create_visa]

    test "deletes chosen visa", %{conn: conn, visa: visa} do
      conn = delete(conn, Routes.visa_path(conn, :delete, visa))
      assert redirected_to(conn) == Routes.visa_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.visa_path(conn, :show, visa))
      end
    end
  end

  defp create_visa(_) do
    visa = fixture(:visa)
    {:ok, visa: visa}
  end
end
