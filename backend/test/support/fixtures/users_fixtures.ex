defmodule TimeManager.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "john.doe@email.com",
        username: "john_doe",
        password: "Testyy1234!?",
        password_confirmation: "Testyy1234!?"
      })
      |> TimeManager.Users.create_user()

    user
  end
end
