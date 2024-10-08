defmodule TimeManager.ClocksTest do
  use TimeManager.DataCase

  alias TimeManager.Clocks

  describe "clocks" do
    alias TimeManager.Clocks.Clock

    import TimeManager.ClocksFixtures
    import TimeManager.UsersFixtures

    @invalid_attrs %{status: nil, time: nil, user_id: nil}

    setup do
      user = user_fixture()
      {:ok, user: user}
    end

    test "list_clocks/0 returns all user clocks", %{user: user} do
      clock = clock_fixture(%{user_id: user.id})
      assert Clocks.list_user_clocks(user.id) == [clock]
    end

    test "create_clock/1 with valid data creates a clock", %{user: user} do
      valid_attrs = %{status: true, time: ~N[2024-10-07 07:38:00], user_id: user.id}

      assert {:ok, %Clock{} = clock} = Clocks.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2024-10-07 07:38:00]
      assert clock.user_id == user.id
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clocks.create_clock(@invalid_attrs)
    end

    test "change_clock/1 returns a clock changeset", %{user: user} do
      clock = clock_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Clocks.change_clock(clock)
    end
  end
end
