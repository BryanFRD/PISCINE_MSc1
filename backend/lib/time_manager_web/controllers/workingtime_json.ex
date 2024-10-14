defmodule TimeManagerWeb.WorkingtimeJSON do
  alias TimeManager.Repo
  alias TimeManager.Workingtimes.Workingtime

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    for(workingtime <- workingtimes, do: data(workingtime))
  end

  @doc """
  Renders a list of workingtimes.
  """
  def paginate(%{workingtimes: workingtimes}) do
    data = for(workingtime <- workingtimes.data, do: data(workingtime))

    %{
      data: data,
      meta: workingtimes.meta
    }
  end

  @doc """
  Renders a single workingtime.
  """
  def show(%{workingtime: workingtime}) do
    data(workingtime)
  end

  defp data(%Workingtime{} = workingtime) do
    workingtime = Repo.preload(workingtime, :user)

    %{
      id: workingtime.id,
      start: workingtime.start,
      end: workingtime.end,
      user: %{
        id: workingtime.user.id,
        username: workingtime.user.username,
        email: workingtime.user.email
      }
    }
  end
end
