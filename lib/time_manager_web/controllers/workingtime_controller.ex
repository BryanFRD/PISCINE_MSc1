defmodule TimeManagerWeb.WorkingtimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Workingtimes
  alias TimeManager.Workingtimes.Workingtime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"user_id" => user_id} = params) do
    workingtimes = Workingtimes.list_user_workingtimes(user_id, params)
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"user_id" => user_id, "workingtime" => workingtime_params}) do
    workingtime_params = Map.put(workingtime_params, "user_id", user_id)

    with {:ok, %Workingtime{} = workingtime} <-
           Workingtimes.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    workingtime = Workingtimes.get_user_workingtime!(user_id, id)
    render(conn, :show, workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <-
           Workingtimes.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Workingtimes.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
