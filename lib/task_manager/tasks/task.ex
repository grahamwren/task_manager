defmodule TaskManager.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :time_worked, :integer, default: 0
    field :title, :string
    belongs_to :user, TaskManager.Users.User

    has_many :time_blocks, TaskManager.TimeBlocks.TimeBlock

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :time_worked, :completed, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_length(:title, max: 255)
    |> validate_length(:description, max: 255)
    |> validate_required([:title, :user_id])
  end
end
