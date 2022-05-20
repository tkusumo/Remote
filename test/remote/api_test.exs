defmodule Remote.APITest do
  use Remote.DataCase

  alias Remote.API
  alias Remote.Helpers
  alias Remote.Runtime.Server

  describe "API" do
    setup do
      GenServer.start_link(Server, nil, name: __MODULE__)

      Helpers.setup_users(100)

      :ok
    end

    test "get_2_users" do
      %{timestamp: ts, users: users} = API.get_2_users()

      assert ts == nil
      assert Enum.count(users) == 2
    end
  end
end
