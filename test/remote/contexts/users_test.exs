defmodule Remote.Contexts.UsersTest do
  use Remote.DataCase

  alias Remote.Contexts.Users
  alias Remote.Helpers
  alias Remote.Schemas.User
  alias Remote.Repo

  describe "Users context" do
    test "insert_users!/1" do
      users = Users.insert_users!(100)

      assert users.num_rows == 100
    end

    test "update_all_points" do
      Users.insert_users!(5)

      users = Repo.all(User)

      assert Enum.count(users) == 5

      Enum.each(users, fn user ->
        assert user.points == 0
      end)

      Users.update_all_points()

      users = Repo.all(User)

      Enum.each(users, fn user ->
        assert user.points > 0
      end)
    end

    test "get_users_gt_max_num_by/2" do
      Helpers.setup_users(100)

      max_num = 5

      users = Users.get_users_gt_max_num_by(max_num, 2)

      assert Enum.count(users) == 2

      Enum.each(users, fn user ->
        assert user.points > max_num
      end)
    end
  end
end
