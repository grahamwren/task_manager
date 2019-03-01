defmodule TaskManagerWeb.SessionController do
  use TaskManagerWeb, :controller

  def create(conn, %{"email" => email}) do
    user = TaskManager.Users.get_user_by_email(email)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.email}")
      |> redirect(to: page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end