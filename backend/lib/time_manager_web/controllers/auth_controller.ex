defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManager.Users.Guardian

  action_fallback TimeManagerWeb.FallbackController

  def register(conn, user_params) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token} <- Users.generate_token(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:token, user: user, token: token)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %{user: %User{} = user, token: token}} <- Users.authenticate_user(email, password) do
      render(conn, :token, user: user, token: token)
    end
  end

  def profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, :profile, user: user)
  end
end
