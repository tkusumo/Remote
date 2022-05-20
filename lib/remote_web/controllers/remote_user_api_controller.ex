defmodule RemoteWeb.RemoteUserAPIController do
  use Plug.Builder

  alias Remote.API

  plug :get_2_users

  @spec get_2_users(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def get_2_users(conn, _params) do
    result = API.get_2_users()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      200,
      Jason.encode!(result)
    )
  end
end
