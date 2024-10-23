defmodule TimeManagerWeb.TeamJSON do
  alias TimeManager.Repo
  alias TimeManager.Teams.Team

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    for(team <- teams, do: data(team))
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    data(team)
  end

  def error(%{message: message}) do
    %{error: message}
  end

  defp data(%Team{} = team) do
    team = Repo.preload(team, [:managers, :users])

    %{
      id: team.id,
      name: team.name,
      managers:
        for(
          manager <- team.managers,
          do: %{
            id: manager.id,
            username: manager.username,
            email: manager.email
          }
        ),
      users:
        for(
          user <- team.users,
          do: %{
            id: user.id,
            username: user.username,
            email: user.email
          }
        )
    }
  end
end
