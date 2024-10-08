defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock

  action_fallback TimeManagerWeb.FallbackController

  def swagger_definitions do
    %{
      Clock:
        swagger_schema do
          title("Clock")
          description("Timestamp of clock in or out for a user")

          properties do
            id(:string, "Unique identifier for the clock", required: true)
            time(:datetime, "Time of day", required: true)
            status(:boolean, "Indicates whether the clock is in or out", required: true)
            user(:User, "The user creating this clock", required: true)
          end

          example(%{
            id: 1,
            time: "2024-10-08 12:00:00",
            status: true,
            user: %{
              id: 1,
              username: "john_doe",
              email: "john.doe@email.com"
            }
          })
        end,
      Clocks:
        swagger_schema do
          title("Clocks")
          description("A collection of Clocks")
          type(:array)
          items(Schema.ref(:Clock))
        end,
      ClockAttributes:
        swagger_schema do
          title("ClockAttributes")
          description("Attributes for creating a clock")

          properties do
            time(:datetime, "Timestamp for clock", required: true)
            status(:boolean, "Clock in or out", required: true)
          end

          example(%{
            clock: %{
              time: "2024-10-08 12:00:00",
              status: true
            }
          })
        end
    }
  end

  def index(conn, %{"user_id" => user_id}) do
    clocks = Clocks.list_user_clocks(user_id)
    render(conn, :index, clocks: clocks)
  end

  swagger_path :index do
    get("/clocks/{user_id}")
    description("Show all user's clocks")

    parameters do
      user_id(:path, :string, "Unique identifier for the user", required: true)
    end

    response(200, "Success", Schema.ref(:Clocks))
  end

  def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    clock_params = Map.put(clock_params, "user_id", user_id)

    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  swagger_path :create do
    post("/clocks/{user_id}")
    description("Create a clock for a user")

    parameters do
      user_id(:path, :string, "Unique identifier for the user", required: true)
      clock(:body, Schema.ref(:ClockAttributes), "Clock attributes", required: true)
    end

    response(201, "Successfuly created", Schema.ref(:Clock))
    response(400, "Bad request")
    response(422, "Unprocessable entity")
    response(404, "User not found")
  end
end
