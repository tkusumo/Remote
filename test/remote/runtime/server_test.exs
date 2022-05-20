defmodule Remote.Runtime.ServerTest do
  use Remote.DataCase

  alias Remote.Helpers
  alias Remote.Runtime.Server

  describe "GenServer" do
    setup do
      {:ok, remote_server} = GenServer.start_link(Server, nil, name: __MODULE__)

      Helpers.setup_users(500)

      [remote_server: remote_server]
    end

    test "call to get 2 users", %{remote_server: remote_server} do
      state = GenServer.call(remote_server, :server_state)

      %{timestamp: ts, users: users} = GenServer.call(remote_server, :get_2_users)

      refute ts
      assert Enum.count(users) == 2

      Enum.each(users, fn user ->
        assert user.points > state.max_number
      end)

      %{timestamp: ts, users: users} = GenServer.call(remote_server, :get_2_users)

      assert ts > state.timestamp

      Enum.each(users, fn user ->
        assert user.points > state.max_number
      end)
    end
  end
end
