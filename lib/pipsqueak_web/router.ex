defmodule PipsqueakWeb.Router do
  use PipsqueakWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PipsqueakWeb do
    pipe_through :browser

    get "/", PageController, :index
    live_dashboard "/dashboard", metrics: PipsqueakWeb.Telemetry
    get "/:echo", PageController, :echo
  end

  # Other scopes may use custom stacks.
  # scope "/api", PipsqueakWeb do
  #   pipe_through :api
  # end
end
