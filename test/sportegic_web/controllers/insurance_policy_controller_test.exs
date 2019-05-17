defmodule SportegicWeb.InsurancePolicyControllerTest do
  use SportegicWeb.ConnCase

  alias Sportegic.People

  @create_attrs %{additional_info: "some additional_info", coverage_amount: 42, expiry_date: ~D[2010-04-17], issuer: "some issuer", number: "some number"}
  @update_attrs %{additional_info: "some updated additional_info", coverage_amount: 43, expiry_date: ~D[2011-05-18], issuer: "some updated issuer", number: "some updated number"}
  @invalid_attrs %{additional_info: nil, coverage_amount: nil, expiry_date: nil, issuer: nil, number: nil}

  def fixture(:insurance_policy) do
    {:ok, insurance_policy} = People.create_insurance_policy(@create_attrs)
    insurance_policy
  end

  describe "index" do
    test "lists all insurance_policies", %{conn: conn} do
      conn = get(conn, Routes.insurance_policy_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Insurance policies"
    end
  end

  describe "new insurance_policy" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.insurance_policy_path(conn, :new))
      assert html_response(conn, 200) =~ "New Insurance policy"
    end
  end

  describe "create insurance_policy" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.insurance_policy_path(conn, :create), insurance_policy: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.insurance_policy_path(conn, :show, id)

      conn = get(conn, Routes.insurance_policy_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Insurance policy"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.insurance_policy_path(conn, :create), insurance_policy: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Insurance policy"
    end
  end

  describe "edit insurance_policy" do
    setup [:create_insurance_policy]

    test "renders form for editing chosen insurance_policy", %{conn: conn, insurance_policy: insurance_policy} do
      conn = get(conn, Routes.insurance_policy_path(conn, :edit, insurance_policy))
      assert html_response(conn, 200) =~ "Edit Insurance policy"
    end
  end

  describe "update insurance_policy" do
    setup [:create_insurance_policy]

    test "redirects when data is valid", %{conn: conn, insurance_policy: insurance_policy} do
      conn = put(conn, Routes.insurance_policy_path(conn, :update, insurance_policy), insurance_policy: @update_attrs)
      assert redirected_to(conn) == Routes.insurance_policy_path(conn, :show, insurance_policy)

      conn = get(conn, Routes.insurance_policy_path(conn, :show, insurance_policy))
      assert html_response(conn, 200) =~ "some updated additional_info"
    end

    test "renders errors when data is invalid", %{conn: conn, insurance_policy: insurance_policy} do
      conn = put(conn, Routes.insurance_policy_path(conn, :update, insurance_policy), insurance_policy: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Insurance policy"
    end
  end

  describe "delete insurance_policy" do
    setup [:create_insurance_policy]

    test "deletes chosen insurance_policy", %{conn: conn, insurance_policy: insurance_policy} do
      conn = delete(conn, Routes.insurance_policy_path(conn, :delete, insurance_policy))
      assert redirected_to(conn) == Routes.insurance_policy_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.insurance_policy_path(conn, :show, insurance_policy))
      end
    end
  end

  defp create_insurance_policy(_) do
    insurance_policy = fixture(:insurance_policy)
    {:ok, insurance_policy: insurance_policy}
  end
end
