defmodule TimeManagerWeb.WorkingtimeController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Workingtimes
  alias TimeManager.Workingtimes.Workingtime

  action_fallback TimeManagerWeb.FallbackController

  def swagger_definitions do
    %{
      Workingtime:
        swagger_schema do
          title("Workingtime")
          description("A user's working time")

          properties do
            id(:number, "Unique identifier for the user", required: true)
            start(:datetime, "The start time of the working time", required: true)
            end_time(:datetime, "The end time of the working time (field: 'end')", required: true)
            user(:User, "The user creating this working time", required: true)
          end

          example(%{
            id: 1,
            start: "2024-10-08 08:00:00",
            end: "2024-10-08 17:00:00",
            user: %{
              id: 1,
              username: "john_doe",
              email: "john.doe@email.com"
            }
          })
        end,
      Workingtimes:
        swagger_schema do
          title("Workingtimes")
          description("A collection of Workingtimes")
          type(:array)
          items(Schema.ref(:Workingtime))
        end,
      WorkingtimeAttributes:
        swagger_schema do
          title("WorkingtimeAttributes")
          description("Attributes for creating or updating a workingtime")

          properties do
            start(:datetime, "The start time of the working time", required: true)
            end_time(:datetime, "The end time of the working time", required: true)
          end

          example(%{
            start: "2024-10-08 08:00:00",
            end: "2024-10-08 17:00:00"
          })
        end
    }
  end

  def index(conn, %{"user_id" => user_id} = params) do
    workingtimes = Workingtimes.list_user_workingtimes(user_id, params)
    render(conn, :index, workingtimes: workingtimes)
  end

  swagger_path :index do
    get("/workingtimes/{user_id}")
    description("List all user workingtimes")

    parameters do
      user_id(:path, :string, "Unique identifier for the user", required: true)
      start(:query, :datetime, "The start time of the working time", required: false)

      end_time(:query, :datetime, "The end time of the working time (field: 'end')",
        required: false
      )

      order_by(:query, :string, "Order by start or end time", required: false)
      order(:query, :string, "Order direction", required: false)
    end

    response(200, "List of user workingtimes", Schema.ref(:Workingtimes))
    response(404, "User not found")
  end

  def create(conn, workingtime_params) do
    Users.get_user!(workingtime_params["user_id"])

    with {:ok, %Workingtime{} = workingtime} <-
           Workingtimes.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    end
  end

  swagger_path :create do
    post("/workingtimes/{user_id}")
    description("Create a new workingtime for a user")

    parameters do
      user_id(:path, :string, "Unique identifier for the user", required: true)

      attributes(:body, Schema.ref(:WorkingtimeAttributes), "Workingtime attributes",
        required: true
      )
    end

    response(201, "Successfuly created workingtime", Schema.ref(:Workingtime))
    response(400, "Bad request")
    response(422, "Unprocessable entity")
    response(404, "User not found")
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    workingtime = Workingtimes.get_user_workingtime!(user_id, id)
    render(conn, :show, workingtime: workingtime)
  end

  swagger_path :show do
    get("/workingtimes/{user_id}/{id}")
    description("Show a single workingtime")

    parameters do
      user_id(:path, :string, "Unique identifier for the user", required: true)
      id(:path, :string, "Unique identifier for the workingtime", required: true)
    end

    response(200, "Workingtime", Schema.ref(:Workingtime))
    response(404, "Workingtime not found")
  end

  def update(conn, %{"id" => id} = workingtime_params) do
    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <-
           Workingtimes.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  swagger_path :update do
    put("/workingtimes/{id}")
    description("Update workingtime")

    parameters do
      id(:path, :string, "Unique identifier for the workingtime", required: true)

      attributes(:body, Schema.ref(:WorkingtimeAttributes), "Workingtime attributes",
        required: true
      )
    end

    response(200, "Updated workingtime", Schema.ref(:Workingtime))
    response(400, "Bad request")
    response(404, "Workingtime not found")
    response(422, "Unprocessable entity")
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Workingtimes.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/workingtimes/{id}")
    description("Delete workingtime")

    parameters do
      id(:path, :string, "Unique identifier for the workingtime", required: true)
    end

    response(200, "Successfully deleted")
    response(404, "Workingtime not found")
  end
end
