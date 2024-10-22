defmodule TimeManagerWeb.AuthJSON do
  @doc """
  Renders a user and token as JSON.
  """
  def token(%{user: user, token: token}) do
    %{
      token: token,
      user: %{
        id: user.id,
        username: user.username,
        email: user.email
      }
    }
  end

  def profile(%{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
