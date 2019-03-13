defmodule TaskManager.TimeBlocks.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset


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
    |> validate_inclusion(:start_time, 0..DateTime.to_unix(DateTime.utc_now), message: "cannot be in future")
    |> validate_inclusion(:end_time, 0..DateTime.to_unix(DateTime.utc_now), message: "cannot be in future")
    |> IO.inspect
    |> validate_required([:start_time])
    |> fn time_block_changeset ->
         if attrs["end_time"],
           do: validate_inclusion(time_block_changeset, :end_time,
             (attrs["start_time"])..(DateTime.to_unix(DateTime.utc_now)), message: "must be greater than start time"),
           else: time_block_changeset
       end.()
  end
end
