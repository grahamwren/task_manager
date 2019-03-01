defmodule TaskManagerWeb.Plugs.RequireLogin do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    if conn.assigns.current_user,
      do: conn,
      else: conn
            |> Phoenix.Controller.put_flash(:info, "You must be logged in")
            |> Phoenix.Controller.put_view(TaskManagerWeb.PageView)
            |> Phoenix.Controller.put_layout({TaskManagerWeb.LayoutView, "app.html"})
            |> Phoenix.Controller.render("index.html")
            |> halt
  end
end