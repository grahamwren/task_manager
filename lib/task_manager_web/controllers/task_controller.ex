defmodule TaskManagerWeb.TaskController do
  use TaskManagerWeb, :controller

  alias TaskManager.Tasks
  alias TaskManager.Users
  alias TaskManager.Repo
  alias TaskManager.Tasks.Task

  def index(conn, _params) do
    tasks = Users.get_tasks(conn.assigns.current_user)
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    current_user = conn.assigns.current_user
    changeset = Tasks.change_task(%Task{})
    possible_task_owners = Enum.map(Users.get_underlings(current_user), fn u ->
      {u.name || u.email, u.id}
    end)
    render(conn, "new.html", changeset: changeset, owners: possible_task_owners)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task =
      Tasks.get_task!(id)
      |> Repo.preload([:user])
    if authenticate_task(task, conn.assigns.current_user) do
      render(conn, "show.html", task: task)
    else
      conn
      |> put_flash(:error, "Task belongs to a different user")
      |> redirect(to: "/")
    end
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    current_user = conn.assigns.current_user
    possible_task_owners = Enum.map(Users.get_underlings(current_user), fn u ->
      {u.name || u.email, u.id}
    end)
    if authenticate_task(task, conn.assigns.current_user) do
      render(conn, "edit.html", task: task, changeset: changeset, owners: possible_task_owners)
    else
      conn
      |> put_flash(:error, "Task belongs to a different user")
      |> redirect(to: "/")
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)
    if authenticate_task(task, conn.assigns.current_user) do
      case Tasks.update_task(task, task_params) do
        {:ok, _task} ->
          conn
          |> put_flash(:info, "Task updated successfully.")
          |> redirect(to: task_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", task: task, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Task belongs to a different user")
      |> redirect(to: "/")
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    if authenticate_task(task, conn.assigns.current_user) do
      {:ok, _task} = Tasks.delete_task(task)

      conn
      |> put_flash(:info, "Task deleted successfully.")
      |> redirect(to: task_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Task belongs to a different user")
      |> redirect(to: "/")
    end
  end
end
