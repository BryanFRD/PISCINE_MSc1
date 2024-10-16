defmodule TimeManagerWeb.WorkingtimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.WorkingtimesFixtures
  import TimeManager.UsersFixtures

  alias TimeManager.Workingtimes.Workingtime

  @create_attrs %{
    start: ~N[2024-10-07 09:00:00],
    end: ~N[2024-10-07 18:00:00]
  }
  @update_attrs %{
    start: ~N[2024-10-08 09:00:00],
    end: ~N[2024-10-08 18:00:00]
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
  end

  describe "index" do
    test "lists all user workingtimes", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/workingtimes/#{user.id}")
      assert json_response(conn, 200) == []
    end
  end

  describe "create workingtime" do
    test "renders workingtime when data is valid", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/workingtimes/#{user.id}", @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/workingtimes/#{user.id}/#{id}")

      assert %{
               "id" => ^id,
               "start" => "2024-10-07T09:00:00",
               "end" => "2024-10-07T18:00:00"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/workingtimes/#{user.id}", @invalid_attrs)
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
      conn = put(conn, ~p"/api/workingtimes/#{workingtime}", @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/workingtimes/#{user.id}/#{id}")

      assert %{
               "id" => ^id,
               "start" => "2024-10-08T09:00:00",
               "end" => "2024-10-08T18:00:00"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, workingtime: workingtime} do
      conn = put(conn, ~p"/api/workingtimes/#{workingtime}", @invalid_attrs)
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
