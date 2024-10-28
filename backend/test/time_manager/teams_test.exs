defmodule TimeManager.TeamsTest do
  use TimeManager.DataCase

  alias TimeManager.Teams

  describe "teams" do
    alias TimeManager.Teams.Team

    import TimeManager.TeamsFixtures
    import TimeManager.UsersFixtures

    @invalid_attrs %{name: "1", manager_ids: [], user_ids: []}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      list_teams = Teams.list_teams()

      assert length(list_teams) > 0
      assert hd(list_teams).id == team.id
      assert hd(list_teams).name == team.name
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      get_team = Teams.get_team!(team.id)

      assert get_team.id == team.id
      assert get_team.name == team.name
    end

    test "create_team/1 with valid data creates a team" do
      user = user_fixture()
      valid_attrs = %{name: "Team 1", manager_ids: [user.id]}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.name == "Team 1"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "Team updated"}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.name == "Team updated"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)

      get_team = Teams.get_team!(team.id)
      assert get_team.name == team.name
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end
end
