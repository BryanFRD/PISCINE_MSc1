defmodule TimeManagerWeb.WorkingtimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.WorkingtimesFixtures
  import TimeManager.UsersFixtures

  alias TimeManager.Workingtimes.Workingtime

  @create_attrs %{
    start: ~N[2024-10-07 09:40:00],
    end: ~N[2024-10-07 09:40:00]
  }
  @update_attrs %{
    start: ~N[2024-10-08 09:40:00],
    end: ~N[2024-10-08 09:40:00]
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
  end

  describe "index" do
    test "lists all user workingtimes", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/workingtimes/#{user.id}")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workingtime" do
    test "renders workingtime when data is valid", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/workingtimes/#{user.id}", workingtime: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workingtimes/#{user.id}/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-07T09:40:00",
               "start" => "2024-10-07T09:40:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/workingtimes/#{user.id}", workingtime: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workingtime" do
    setup [:create_workingtime]

    test "renders workingtime when data is valid", %{
      conn: conn,
      user: user,
      workingtime: %Workingtime{id: id} = workingtime
    } do
      conn = put(conn, ~p"/api/workingtimes/#{workingtime}", workingtime: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workingtimes/#{user.id}/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-08T09:40:00",
               "start" => "2024-10-08T09:40:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workingtime: workingtime} do
      conn = put(conn, ~p"/api/workingtimes/#{workingtime}", workingtime: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workingtime" do
    setup [:create_workingtime]

    test "deletes chosen workingtime", %{conn: conn, workingtime: workingtime, user: user} do
      conn = delete(conn, ~p"/api/workingtimes/#{workingtime}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workingtimes/#{user.id}/#{workingtime}")
      end
    end
  end

  defp create_workingtime(%{user: user}) do
    workingtime = workingtime_fixture(%{user_id: user.id})
    %{workingtime: workingtime}
  end
end