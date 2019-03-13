defmodule TaskManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :name, :string

    has_many :tasks, TaskManager.Tasks.Task
    has_many :underlings, TaskManager.Users.User, foreign_key: :manager_id
    belongs_to :manager, TaskManager.Users.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :manager_id])
    |> cast_assoc(:manager)
    |> unique_constraint(:email)
    |> validate_required([:email])
  end
end
