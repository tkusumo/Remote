defmodule RemoteWeb.Router do
  use RemoteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RemoteWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RemoteWeb do
    pipe_through :api

    get "/", RemoteUserAPIController, :get_2_users
  end

  # Other scopes may use custom stacks.
  # scope "/api", RemoteWeb do
  #   pipe_through :api
  # end
end
