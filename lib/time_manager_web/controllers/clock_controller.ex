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
            time(:naive_datetime, "Time of day", required: true)
            status(:boolean, "Clock in or out", required: true)
            user(:User, "User creating this clock", required: true)
            id(:string, "Unique identifier", required: true)
          end

          example(%{
            time: "2024-10-08 12:52:03",
            status: "true",
            user: %{
              username: "John",
              email: "john@mail.com",
              id: "123"
            },
            id: "12345"
          })
        end,
        Clocks:
        swagger_schema do
          title("Clocks")
          description("A collection of Clocks")
          type(:array)
          items(Schema.ref(:Clock))
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
      user_id(:path, :string, "User's ID", required: true)
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
      user_id(:path, :string, "User's ID", required: true)
      time(:body, :naive_datetime, "Timestamp for clock", required: true)
      status(:body, :boolean, "Clock in or out", required: true)
    end

    response(201, "Successfuly created", Schema.ref(:Clock))
  end
end
