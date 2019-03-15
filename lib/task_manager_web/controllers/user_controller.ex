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

  def index(conn, _params) do
    if conn.assigns.current_user do
      users = Users.list_users
      render(conn, "index.html", users: users)
    else
      conn
      |> put_flash(:error, "Unauthorized to see this user")
      |> redirect(to: "/")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id) |> Users.preload(:underlings)
    if conn.assigns.current_user && authenticate_user(user, conn.assigns.current_user) do
      render(conn, "show.html", user: user)
    else
      conn
      |> put_flash(:error, "Unauthorized to see this user")
      |> redirect(to: "/")
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    if conn.assigns.current_user && authenticate_user(user, conn.assigns.current_user) do
      changeset = Users.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      conn
      |> put_flash(:error, "Unauthorized to edit this user")
      |> redirect(to: "/")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    if conn.assigns.current_user && authenticate_user(user, conn.assigns.current_user) do
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

  def manage(conn, %{"user_id" => user_id}) do
    current_user = conn.assigns.current_user
    user = Users.get_user!(user_id)
    if current_user && user do
      with {:ok, user} <- Users.update_user(user, %{manager_id: current_user.id}) do
        user = %User{user | manager: current_user}
        conn
        |> put_status(:ok)
        |> render("show.json", user: user)
      end
    else
      conn
      |> put_status(:bad_request)
      |> send_resp(:no_content, "")
    end
  end
end
