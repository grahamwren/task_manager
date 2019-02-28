defmodule TaskManager.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskManager.User
  alias TaskManager.Task

  schema "users" do
    field :name, :string
    field :email, :string
    has_many :tasks, Task

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email])
    |> validate_required([:name, :email])
  end
end
