defmodule TaskManager.TimeBlocks.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset
  import TaskManager.Utils


  schema "time_blocks" do
    field :start_time, :integer
    field :end_time, :integer
    belongs_to :task, TaskManager.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(time_block, attrs) do
    time_block
    |> cast(attrs, [:start_time, :end_time, :task_id])
    |> foreign_key_constraint(:user_id)
    |> validate_inclusion(:start_time, 0..now(), message: "cannot be in future")
    |> validate_inclusion(:end_time, 0..now(), message: "cannot be in future")
    |> validate_required([:start_time])
    |> fn time_block_changeset ->
         start_time = Map.get(time_block_changeset.changes, :start_time) || time_block.start_time
         end_time = Map.get(time_block_changeset.changes, :end_time)
         if end_time,
           do: validate_inclusion(time_block_changeset, :end_time,
             start_time..end_time, message: "must be greater than start time"),
           else: time_block_changeset
       end.()
    |> IO.inspect()
  end
end
