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
end
