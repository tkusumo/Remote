defmodule RemoteWeb.RemoteUserAPIControllerTest do
  use RemoteWeb.ConnCase

  alias Remote.Helpers

  describe "API controller test" do
    setup do
      Helpers.setup_users(100)

      :ok
    end

    test "get_2_users API", %{conn: conn} do
      %{"timestamp" => ts, "users" => users} =
        conn
        |> get(Routes.remote_user_api_path(conn, :get_2_users))
        |> json_response(200)

      assert ts == nil
      assert Enum.count(users) == 2

      %{"timestamp" => ts, "users" => users} =
        conn
        |> get(Routes.remote_user_api_path(conn, :get_2_users))
        |> json_response(200)

      assert ts != nil
      assert Enum.count(users) == 2
    end
  end
end
