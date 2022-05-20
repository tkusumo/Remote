defmodule Remote.Contexts.Users do
  @moduledoc """
    Contains Users context
  """

  import Ecto.Query

  alias Ecto.Adapters.SQL
  alias Remote.Repo
  alias Remote.Schemas.User

  @max_users 1_000_000
  @min_range 1
  @max_range 100
  @default_points 0

  @spec delete_all() :: {non_neg_integer(), nil | [term()]}
  def delete_all() do
    Repo.delete_all(User)
  end

  @spec insert_users!(integer()) :: %{
          :rows => nil | [[term()] | binary()],
          :num_rows => non_neg_integer(),
          optional(atom()) => any()
        }
  def insert_users!(count \\ @max_users) do
    now = DateTime.utc_now()

    SQL.query!(
      Repo,
      "
      insert into users (points, inserted_at, updated_at)
      select $1, $2, $2
      from generate_series(1, $3)
      ",
      [@default_points, now, count]
    )
  end

  @spec update_all_points() :: %{
          :rows => nil | [[term()] | binary()],
          :num_rows => non_neg_integer(),
          optional(atom()) => any()
        }
  def update_all_points() do
    SQL.query!(
      Repo,
      "
      update users
      set points = floor(random()*(#{@max_range}-#{@min_range}+1))+#{@min_range}
      "
    )
  end

  @spec get_users_gt_max_num_by(integer(), integer()) :: list()
  def get_users_gt_max_num_by(max_num, limit \\ 0) do
    user_query()
    |> gt_max_number_query(max_num)
    |> with_limit_query(limit)
    |> select_id_and_points()
    |> Repo.all()
  end

  defp user_query() do
    from(u in User)
  end

  defp gt_max_number_query(query, max_num) do
    query
    |> where([u], u.points > ^max_num)
  end

  defp with_limit_query(query, 0), do: query

  defp with_limit_query(query, limit) do
    query
    |> limit([_u], ^limit)
  end

  defp select_id_and_points(query) do
    query
    |> select([u], %{id: u.id, points: u.points})
  end
end
