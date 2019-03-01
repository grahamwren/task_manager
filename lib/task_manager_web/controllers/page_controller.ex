defmodule TaskManagerWeb.PageController do
  use TaskManagerWeb, :controller
  alias TaskManager.Users;

  def index(conn, _params) do
    tasks = if conn.assigns.current_user, do: Users.get_tasks(conn.assigns.current_user), else: nil
    render conn, "index.html", tasks: tasks
  end
end
