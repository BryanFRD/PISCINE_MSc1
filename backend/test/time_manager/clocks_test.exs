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

    test "get_user_clock/0 returns all user clocks", %{user: user} do
      clock = Clocks.get_user_clock!(user.id)
      assert clock.user_id == user.id
    end

    test "update_clock/1 with valid data updates a clock", %{user: user} do
      clock = Clocks.get_user_clock!(user.id)
      valid_attrs = %{status: true, time: ~N[2024-10-07 07:38:00]}

      assert {:ok, %Clock{} = clock} = Clocks.update_clock(clock, valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2024-10-07 07:38:00]
    end

    test "update_clock/1 with invalid data returns error changeset", %{user: user} do
      clock = Clocks.get_user_clock!(user.id)
      assert {:error, %Ecto.Changeset{}} = Clocks.update_clock(clock, @invalid_attrs)
    end

    test "change_clock/1 returns a clock changeset", %{user: user} do
      clock = Clocks.get_user_clock!(user.id)
      assert %Ecto.Changeset{} = Clocks.change_clock(clock)
    end
  end
end
