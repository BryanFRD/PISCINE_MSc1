defmodule TimeManager.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Teams.Team
  alias TimeManager.Users.User

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  @doc """
  Checks if the first user is a manager in the same team as the second user,
  or if the second user is in the team as a user or manager.
  """
  def is_user_manager?(%User{id: manager_id}, %User{id: user_id}) do
    query =
      from t in Team,
        join: tm in assoc(t, :managers),
        join: tu in assoc(t, :users),
        where: tm.id == ^manager_id and (tu.id == ^user_id or tm.id == ^user_id),
        select: t.id

    Repo.exists?(query)
  end

  def is_manager?(%Team{id: team_id}, %User{id: manager_id}) do
    query =
      from t in Team,
        join: tm in assoc(t, :managers),
        where: t.id == ^team_id and tm.id == ^manager_id,
        select: t.id

    Repo.exists?(query)
  end

  def is_user?(%Team{id: team_id}, %User{id: user_id}) do
    query =
      from t in Team,
        join: tu in assoc(t, :users),
        where: t.id == ^team_id and tu.id == ^user_id,
        select: t.id

    Repo.exists?(query)
  end
end
