defmodule TaskManagerWeb.UserView do
  use TaskManagerWeb, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    user = case user.manager do
      %{id: id} -> user
      _ -> %{user | manager: nil}
    end
    %{id: user.id,
      name: user.name,
      email: user.email,
      manager_id: user.manager_id,
      manager: user.manager}
  end
end
