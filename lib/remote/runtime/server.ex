defmodule Remote.Runtime.Server do
  use GenServer

  alias Remote.Contexts.Users

  defstruct [:max_number, :timestamp]

  @type t :: %__MODULE__{
          max_number: integer,
          timestamp: String.t()
        }

  @time_interval 60_000

  # client

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  # server

  @impl true
  def init(_args) do
    rand = Enum.random(1..100)

    :timer.send_interval(@time_interval, :update_every_user_points)

    {:ok, %__MODULE__{max_number: rand, timestamp: nil}}
  end

  @impl true
  def handle_info(:update_every_user_points, state) do
    rand = Enum.random(1..100)

    Users.update_all_points()

    state =
      state
      |> Map.put(:max_number, rand)

    {:noreply, state}
  end

  @impl true
  def handle_call(:get_2_users, _from, state) do
    users = Users.get_users_gt_max_num_by(state.max_number, 2)

    return = %{users: users, timestamp: state.timestamp}

    state =
      state
      |> Map.put(:timestamp, format_timestamp(DateTime.utc_now()))

    {:reply, return, state}
  end

  def handle_call(:server_state, _from, state), do: {:reply, state, state}

  defp format_timestamp(ts) do
    ts
    |> DateTime.to_string()
    |> String.slice(0..18)
  end
end
