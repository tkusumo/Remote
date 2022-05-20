defmodule Remote.API do
  @moduledoc """
    Contains APIs
  """

  alias Remote.Runtime.Server

  @doc """
  Example output:
  %{
    users: [%{id: 281, points: 67}, %{id: 282, points: 78}],
    timestamp: ~U[2022-05-19 21:05:40.636668Z]
  }
  """
  @spec get_2_users() :: map()
  def get_2_users() do
    GenServer.call(Server, :get_2_users)
  end
end
