defmodule TaskManagerWeb.UserController do
  use TaskManagerWeb, :controller

  alias TaskManager.Users
  alias TaskManager.Users.User

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # require authorization

  def show(conn, %{"id" => id}) do
    if conn.assigns.current_user && conn.assigns.current_user.id === id do
      user = Users.get_user!(id)
      render(conn, "show.html", user: user)
    else
      conn
      |> put_flash(:error, "Unauthorized to see this user")
      |> redirect(to: "/")
    end
  end

  def edit(conn, %{"id" => id}) do
    if conn.assigns.current_user && conn.assigns.current_user.id === id do
      user = Users.get_user!(id)
      changeset = Users.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      conn
      |> put_flash(:error, "Unauthorized to edit this user")
      |> redirect(to: "/")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    if conn.assigns.current_user && conn.assigns.current_user.id === id do
      user = Users.get_user!(id)

      case Users.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :show, user))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Unauthorized to edit this user")
      |> redirect(to: "/")
    end
  end

  def delete(conn, %{"id" => id}) do
    if conn.assigns.current_user && conn.assigns.current_user.id === id do
      user = Users.get_user!(id)
      {:ok, _user} = Users.delete_user(user)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: user_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Unauthorized to delete this user")
      |> redirect(to: "/")
    end
  end
end
