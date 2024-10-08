defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    # Users
    resources "/users", UserController, except: [:new, :edit]

    # Clocks
    get "/clocks/:user_id", ClockController, :index
    post "/clocks/:user_id", ClockController, :create
  end

  def swagger_info do
    %{
      basePath: "/api",
      info: %{
        version: "1.0",
        title: "Time Manager"
      }
    }
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :time_manager,
      swagger_file: "swagger.json"
  end
end
