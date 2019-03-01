defmodule TaskManagerWeb.Router do
  use TaskManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TaskManagerWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_logged_in do
    plug TaskManagerWeb.Plugs.RequireLogin
  end

  scope "/", TaskManagerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
    resources "/users", UserController, only: [:new, :create, :show, :edit, :update, :delete]

    pipe_through :require_logged_in
    resources "/tasks", TaskController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskManagerWeb do
  #   pipe_through :api
  # end
end
