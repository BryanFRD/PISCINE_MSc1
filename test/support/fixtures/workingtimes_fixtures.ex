defmodule TimeManager.WorkingtimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Workingtimes` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 09:40:00],
        start: ~N[2024-10-07 09:40:00],
        user_id: attrs[:user_id] || 1
      })
      |> TimeManager.Workingtimes.create_workingtime()

    workingtime
  end
end
