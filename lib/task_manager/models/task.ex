defmodule TaskManager.Models.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :time_worked, :integer, default: 0
    field :title, :string
    belongs_to :user, TaskManager.Models.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :time_worked, :completed])
    |> validate_required([:title])
  end
end
