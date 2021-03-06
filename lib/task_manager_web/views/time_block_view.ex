defmodule TaskManagerWeb.TimeBlockView do
  use TaskManagerWeb, :view
  alias TaskManagerWeb.TimeBlockView

  def render("index.json", %{time_blocks: time_blocks}) do
    %{data: render_many(time_blocks, TimeBlockView, "time_block.json")}
  end

  def render("show.json", %{time_block: time_block}) do
    %{data: render_one(time_block, TimeBlockView, "time_block.json")}
  end

  def render("time_block.json", %{time_block: time_block}) do
    task = time_block.task
    time_block = case task do
      %{id: id} -> %{time_block | task: %{
        id: id,
        title: task.title,
        description: task.description,
        completed: task.completed
      }}
      _ -> %{time_block | task: nil}
    end
    %{id: time_block.id,
      start_time: time_block.start_time,
      end_time: time_block.end_time,
      task: time_block.task}
  end
end
