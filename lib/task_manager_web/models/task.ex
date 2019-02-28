defmodule TaskManager.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskManager.Task
  alias TaskManager.User

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :time_worked, :integer
    field :completed, :boolean, default: false
    belongs_to :user, User, foreign_key: :user_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :time_worked, :completed])
    |> validate_required([:title, :description, :time_worked, :completed])
  end
end
