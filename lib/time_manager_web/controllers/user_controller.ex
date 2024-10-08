defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the application")

          properties do
            username(:string, "Users name", required: true)
            email(:string, "Users email", required: true)
          end

          example(%{
            username: "Joe",
            email: "joe@mail.com"
          })
        end,
      Users:
        swagger_schema do
          title("Users")
          description("A collection of Users")
          type(:array)
          items(Schema.ref(:User))
        end
    }
  end

  def index(conn, params) do
    users = Users.list_users(params)
    render(conn, :index, users: users)
  end

  swagger_path :index do
    get("/users")
    description("List all users")

    parameters do
      username(:query, :string, "Username", required: false)
      email(:query, :string, "User's email", required: false)
    end

    response(200, "Success", Schema.ref(:Users))
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  swagger_path :create do
    post("/users")
    description("Create a new user")

    parameters do
      username(:query, :string, "User's name", required: true)
      email(:query, :string, "User's email", required: true)
    end

    response(200, "Success", Schema.ref(:User))
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  swagger_path :show do
    get("/users/{id}")
    description("Show a single user")
    response(200, "Success", Schema.ref(:User))
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  swagger_path :update do
    put("/users/{id}")
    description("Update user")

    parameters do
      id(:path, :string, "User's ID", required: true)
    end

    response(200, "Success", Schema.ref(:User))
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/users/{id}")
    description("Delete user")
    response(200, "Success")
  end
end
