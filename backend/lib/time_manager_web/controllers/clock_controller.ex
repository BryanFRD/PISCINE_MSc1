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
            time(:datetime, "Time of day", required: false)
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
      ClockAttributes:
        swagger_schema do
          title("ClockAttributes")
          description("Attributes for creating a clock")

          properties do
            time(:datetime, "Timestamp for clock", required: true)
            status(:boolean, "Clock in or out", required: true)
          end

          example(%{
            time: "2024-10-08 12:00:00",
            status: true
          })
        end
    }
  end

  def show(conn, %{"user_id" => user_id}) do
    clock = Clocks.get_user_clock!(user_id)
    render(conn, :show, clock: clock)
  end

  swagger_path :index do
    get("/clocks/{user_id}")
    description("Show user clock")

    parameters do
      user_id(:path, :string, "Unique identifier for the user", required: true)
    end

    response(200, "Success", Schema.ref(:Clock))
  end

  def update(conn, %{"user_id" => user_id} = clock_params) do
    clock = Clocks.get_user_clock!(user_id)

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  swagger_path :update do
    put("/clocks/{user_id}")
    description("Update the clock of a user")

    parameters do
      user_id(:path, :string, "Unique identifier for the user", required: true)
      attributes(:body, Schema.ref(:ClockAttributes), "Clock attributes", required: true)
    end

    response(201, "Successfuly updated", Schema.ref(:Clock))
    response(400, "Bad request")
    response(422, "Unprocessable entity")
    response(404, "Clock not found")
  end
end
