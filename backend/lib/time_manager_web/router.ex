defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TimeManager.Users.Pipeline
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
  end

  scope "/api", TimeManagerWeb do
    pipe_through [:api, :auth]

    # Users
    resources "/users", UserController, except: [:new, :edit]

    # Auth
    get "/auth/profile", AuthController, :profile

    # Clocks
    get "/clocks/:user_id", ClockController, :show
    put "/clocks/:user_id", ClockController, :update

    # Workingtimes
    get "/workingtimes/:user_id", WorkingtimeController, :index
    get "/workingtimes/:user_id/paginate", WorkingtimeController, :paginate
    get "/workingtimes/:user_id/:id", WorkingtimeController, :show
    post "/workingtimes/:user_id", WorkingtimeController, :create
    put "/workingtimes/:id", WorkingtimeController, :update
    delete "/workingtimes/:id", WorkingtimeController, :delete
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
