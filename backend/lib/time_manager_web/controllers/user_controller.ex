defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManager.Users.Guardian

  action_fallback TimeManagerWeb.FallbackController

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the application")

          properties do
            id(:number, "Unique identifier for the user", required: true)
            email(:string, "The user's email address", required: true)
            username(:string, "The user's username", required: true)
          end

          example(%{
            id: 1,
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
        end,
      UserAttributes:
        swagger_schema do
          title("UserAttributes")
          description("Attributes for creating or updating a user")

          properties do
            email(:string, "The user's email address", required: true)
            username(:string, "The user's username", required: true)
          end

          example(%{
            username: "john_doe",
            email: "john.doe@email.com"
          })
        end
    }
  end

  def index(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    users = Users.list_users(params)

    filtered_users =
      Enum.filter(users, fn user ->
        Users.can_manager_user?(current_user, user)
      end)

    render(conn, :index, users: filtered_users)
  end

  swagger_path :index do
    get("/users")
    description("List all users")

    parameters do
      username(:body, :string, "The user's username", required: false)
      email(:body, :string, "The user's email address", required: false)
    end

    response(200, "List of users", Schema.ref(:Users))
  end

  def create(conn, user_params) do
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
      attributes(:body, Schema.ref(:UserAttributes), "User attributes", required: true)
    end

    response(201, "Successfuly created user", Schema.ref(:User))
    response(400, "Bad request")
    response(422, "Unprocessable entity")
  end

  def show(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Users.get_user!(id)

    if Users.can_manager_user?(current_user, user) do
      render(conn, :show, user: user)
    else
      conn
      |> put_status(:forbidden)
      |> render(:error, message: "You are not allowed to see this user")
    end
  end

  swagger_path :show do
    get("/users/{id}")
    description("Show a single user")

    parameters do
      id(:path, :string, "Unique identifier for the user", required: true)
    end

    response(200, "User", Schema.ref(:User))
    response(404, "User not found")
  end

  def update(conn, %{"id" => id} = user_params) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Users.get_user!(id)

    if Users.user_can_manager_user?(current_user, user) do
      with {:ok, %User{} = user} <- Users.update_user(user, user_params, current_user) do
        render(conn, :show, user: user)
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(:error, message: "You are not allowed to modify this user")
    end
  end

  swagger_path :update do
    put("/users/{id}")
    description("Update user")

    parameters do
      id(:path, :string, "Unique identifier for the user", required: true)
      attributes(:body, Schema.ref(:UserAttributes), "User attributes", required: true)
    end

    response(200, "Updated user", Schema.ref(:User))
    response(400, "Bad request")
    response(404, "User not found")
    response(422, "Unprocessable entity")
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Users.get_user!(id)

    if Users.user_can_manager_user?(current_user, user) do
      with {:ok, %User{}} <- Users.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(:error, message: "You are not allowed to delete this user")
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/users/{id}")
    description("Delete user")

    parameters do
      id(:path, :string, "Unique identifier for the user", required: true)
    end

    response(200, "Successfully deleted")
    response(404, "User not found")
  end
end
