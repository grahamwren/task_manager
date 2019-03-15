defmodule TaskManager.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  import TaskManager.Utils
  alias TaskManager.Repo

  alias TaskManager.TimeBlocks
  alias TimeBlocks.TimeBlock
  alias TaskManager.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  def get_task(id), do: Repo.get(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def in_progress?(task) do
    query = from tb in TimeBlock,
                 where: is_nil(tb.end_time) and tb.task_id == ^task.id,
                 select: count(tb.id)
    Repo.one(query) !== 0
  end

  def time_worked(task) do
    task
    |> Ecto.assoc(:time_blocks)
    |> Repo.all
    |> Enum.reduce(0, fn tb, sum -> sum + IO.inspect(((tb.end_time || now()) - tb.start_time)) end)
  end

  def add_time_block(task) do
    TimeBlocks.create_time_block(%{start_time: now(), task_id: task.id})
    task
  end

  def complete_time_blocks(task) do
    # get all time_blocks, sorted by start_time, with indexes
    tbs =
      task
      |> TimeBlocks.list_time_blocks_for_task
      |> Stream.with_index
    # ensure end_time for each:
    #   stop each one at the start time of the next,
    #   then the last at the current time
    Enum.map tbs, fn {tb, i} ->
      if tb.end_time do
        tb
      else
        next_start_time = case Enum.at(tbs, i + 1) do
          {%{start_time: start_time}, _} -> start_time
          _ -> now()
        end

        TimeBlocks.update_time_block(tb, %{end_time: next_start_time})
      end
    end
    task
  end

  def start_working(task) do
    task
    |> complete_time_blocks
    |> add_time_block
  end

  def stop_working(task), do: complete_time_blocks(task)
end