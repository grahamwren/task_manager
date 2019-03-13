defmodule TaskManagerWeb.TimeBlockController do
  use TaskManagerWeb, :controller

  alias TaskManager.TimeBlocks
  alias TaskManager.TimeBlocks.TimeBlock
  alias TaskManager.Tasks

  action_fallback TaskManagerWeb.FallbackController

  def index(conn, %{"task_id" => task_id}) do
    time_blocks = TimeBlocks.list_time_blocks_for_task(task_id)
    render(conn, "index.json", time_blocks: time_blocks)
  end

  def create(conn, %{"time_block" => time_block_params, "task_id" => task_id}) do
    with {:ok, %TimeBlock{} = time_block} <- TimeBlocks.create_time_block(%{time_block_params | "task_id" => task_id}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", task_time_block_path(conn, :show, time_block.task, time_block))
      |> render("show.json", time_block: time_block)
    end
  end

  def show(conn, %{"id" => id}) do
    time_block = TimeBlocks.get_time_block!(id)
    render(conn, "show.json", time_block: time_block)
  end

  def update(conn, %{"id" => id, "time_block" => time_block_params}) do
    time_block = TimeBlocks.get_time_block!(id)

    with {:ok, %TimeBlock{} = time_block} <- TimeBlocks.update_time_block(time_block, time_block_params) do
      render(conn, "show.json", time_block: time_block)
    end
  end

  def delete(conn, %{"id" => id}) do
    time_block = TimeBlocks.get_time_block!(id)
    with {:ok, %TimeBlock{}} <- TimeBlocks.delete_time_block(time_block) do
      send_resp(conn, :no_content, "")
    end
  end

  def start_working(conn, %{"task_id" => task_id}) do
    task = Tasks.get_task!(task_id)
    if authenticate_task(task, conn.assigns.current_user) do
      task = Tasks.start_working(task)
      render(conn, "index.json", time_blocks: TimeBlocks.list_time_blocks_for_task(task))
    else
      conn
      |> put_status(:unauthorized)
      |> send_resp(:no_content, "")
    end
  end

  def stop_working(conn, %{"task_id" => task_id}) do
    task = Tasks.get_task!(task_id)
    if authenticate_task(task, conn.assigns.current_user) do
      task = Tasks.stop_working(task)
      render(conn, "index.json", time_blocks: TimeBlocks.list_time_blocks_for_task(task))
    else
      conn
      |> put_status(:unauthorized)
      |> send_resp(:no_content, "")
    end
  end
end
