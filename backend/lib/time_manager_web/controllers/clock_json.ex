defmodule TimeManagerWeb.ClockJSON do
  alias TimeManager.Repo
  alias TimeManager.Clocks.Clock

  @doc """
  Renders a single clock.
  """
  def show(%{clock: clock}) do
    data(clock)
  end

  defp data(%Clock{} = clock) do
    clock = Repo.preload(clock, :user)

    %{
      id: clock.id,
      time: clock.time,
      status: clock.status,
      user: %{
        id: clock.user.id,
        username: clock.user.username,
        email: clock.user.email
      }
    }
  end
end
