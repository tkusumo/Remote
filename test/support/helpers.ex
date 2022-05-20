defmodule Remote.Helpers do
  @moduledoc """
    Helper functions
  """

  alias Remote.Contexts.Users

  def setup_users(count) do
    Users.insert_users!(count)
    Users.update_all_points()
  end
end
