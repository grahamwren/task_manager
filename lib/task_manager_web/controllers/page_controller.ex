defmodule TaskManagerWeb.PageController do
  use TaskManagerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
