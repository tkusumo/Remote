defmodule Remote.Schemas.User do
  @moduledoc """
    User schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :points, :integer, default: 0

    timestamps()
  end

  @spec changeset(struct(), map()) :: Changeset.t()
  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, [:points])
    |> validate_required([:points])
    |> check_constraint(:points, name: :points_range, message: "points must be between 0 and 100")
  end
end
