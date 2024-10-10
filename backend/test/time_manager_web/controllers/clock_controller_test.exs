defmodule TimeManagerWeb.ClockControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.UsersFixtures

  @update_attrs %{
    status: true,
    time: ~N[2024-10-07 07:38:00]
  }
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
  end

  describe "show clock" do
    test "get user clock", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/clocks/#{user.id}")
      response = json_response(conn, 200)
      assert Map.has_key?(response, "status")
      assert Map.has_key?(response, "time")
    end
  end

  describe "update clock" do
    test "renders clock when data is valid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/clocks/#{user.id}", @update_attrs)

      assert %{"status" => true, "time" => "2024-10-07T07:38:00"} =
               json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/clocks/#{user.id}", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
