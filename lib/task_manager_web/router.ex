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
    plug :fetch_session
  end

  pipeline :require_logged_in do
    plug TaskManagerWeb.Plugs.RequireLogin
  end

  scope "/", TaskManagerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
    resources "/users", UserController

    pipe_through :require_logged_in
    resources "/tasks", TaskController
  end

  # Other scopes may use custom stacks.
   scope "/api/v1", TaskManagerWeb do
     pipe_through :api

     resources "/tasks", TaskController, only: [] do
       post "/start_working", TimeBlockController, :start_working, as: :start
       post "/stop_working", TimeBlockController, :stop_working, as: :stop
       resources "/time_blocks", TimeBlockController, except: [:new, :edit]
     end

     resources "/users", UserController, only: [] do
       post "/manage", UserController, :manage, as: :manage
     end
   end
end
