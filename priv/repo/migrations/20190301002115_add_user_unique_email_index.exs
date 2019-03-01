defmodule TaskManager.Repo.Migrations.AddUserUniqueEmailIndex do
  use Ecto.Migration

  def change do
    TaskManager.Repo.delete_all(TaskManager.Users.User)
    drop index(:users, [:email])
    create unique_index(:users, [:email])
  end
end
