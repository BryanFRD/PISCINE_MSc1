defmodule TimeManager.UsersTest do
  use TimeManager.DataCase

  alias TimeManager.Users
  alias TimeManager.Clocks

  describe "users" do
    alias TimeManager.Users.User

    import TimeManager.UsersFixtures

    @invalid_attrs %{username: nil, email: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      list_users = Users.list_users()

      assert length(list_users) > 0
      assert hd(list_users).id == user.id
      assert hd(list_users).username == user.username
      assert hd(list_users).email == user.email
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      get_user = Users.get_user!(user.id)

      assert get_user.id == user.id
      assert get_user.username == user.username
      assert get_user.email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{username: "john_doe", email: "john.doe@email.com"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.username == "john_doe"
      assert user.email == "john.doe@email.com"

      clock = Clocks.get_user_clock!(user.id)
      assert clock.user_id == user.id
      assert clock.time == nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "john_doe1", email: "john.doe1@email.com"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.username == "john_doe1"
      assert user.email == "john.doe1@email.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)

      get_user = Users.get_user!(user.id)
      assert get_user.username == user.username
      assert get_user.email == user.email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
