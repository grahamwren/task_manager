defmodule TaskManagerWeb.PageController do
  use TaskManagerWeb, :controller
  alias TaskManager.Users;

  def index(conn, _params) do
    user = conn.assigns.current_user
    if user do
      tasks = Users.get_extended_tasks(user)
      users = Users.get_underlings(user)
      render conn, "index.html", tasks: tasks, users: users
    else
      render conn, "index.html"
    end
  end
end
