defmodule TimeManager.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Teams` context.
  """

  import TimeManager.UsersFixtures

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "Team 1",
        manager_ids: [user.id]
      })
      |> TimeManager.Teams.create_team()

    team
  end
end
