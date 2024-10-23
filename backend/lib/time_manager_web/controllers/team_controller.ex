defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Teams.Team
  alias TimeManager.Users.Guardian

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, team_params) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    team = Teams.get_team!(id)

    if Teams.is_user?(team, current_user) or Teams.is_manager?(team, current_user) do
      render(conn, :show, team: team)
    else
      conn
      |> put_status(:forbidden)
      |> render(:error, message: "You are not authorized to view this team")
    end
  end

  def update(conn, %{"id" => id} = team_params) do
    current_user = Guardian.Plug.current_resource(conn)
    team = Teams.get_team!(id)

    if Teams.is_manager?(team, current_user) do
      with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
        render(conn, :show, team: team)
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(:error, message: "You are not authorized to update this team")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    team = Teams.get_team!(id)

    if Teams.is_manager?(team, current_user) do
      with {:ok, %Team{}} <- Teams.delete_team(team) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:forbidden)
      |> render(:error, message: "You are not authorized to delete this team")
    end
  end
end
