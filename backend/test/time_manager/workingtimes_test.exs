defmodule TimeManager.WorkingtimesTest do
  use TimeManager.DataCase

  alias TimeManager.Workingtimes

  describe "workingtimes" do
    alias TimeManager.Workingtimes.Workingtime

    import TimeManager.WorkingtimesFixtures
    import TimeManager.UsersFixtures

    @invalid_attrs %{start: nil, end: nil, user_id: nil}

    setup do
      user = user_fixture()
      {:ok, user: user}
    end

    test "list_workingtimes/0 returns all user workingtimes", %{user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      assert Workingtimes.list_user_workingtimes(user.id) == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id", %{user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      assert Workingtimes.get_user_workingtime!(user.id, workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime", %{user: user} do
      valid_attrs = %{
        start: ~N[2024-10-07 09:40:00],
        end: ~N[2024-10-07 09:40:00],
        user_id: user.id
      }

      assert {:ok, %Workingtime{} = workingtime} = Workingtimes.create_workingtime(valid_attrs)
      assert workingtime.start == ~N[2024-10-07 09:40:00]
      assert workingtime.end == ~N[2024-10-07 09:40:00]
      assert workingtime.user_id == user.id
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workingtimes.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime", %{user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      update_attrs = %{start: ~N[2024-10-08 09:40:00], end: ~N[2024-10-08 09:40:00]}

      assert {:ok, %Workingtime{} = workingtime} =
               Workingtimes.update_workingtime(workingtime, update_attrs)

      assert workingtime.start == ~N[2024-10-08 09:40:00]
      assert workingtime.end == ~N[2024-10-08 09:40:00]
      assert workingtime.user_id == user.id
    end

    test "update_workingtime/2 with invalid data returns error changeset", %{user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})

      assert {:error, %Ecto.Changeset{}} =
               Workingtimes.update_workingtime(workingtime, @invalid_attrs)

      assert workingtime == Workingtimes.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime", %{user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      assert {:ok, %Workingtime{}} = Workingtimes.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> Workingtimes.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset", %{user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Workingtimes.change_workingtime(workingtime)
    end

    test "update_change_workingtime/1 returns a workingtime changeset", %{user: user} do
      workingtime = workingtime_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Workingtimes.update_change_workingtime(workingtime)
    end
  end
end
