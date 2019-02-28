defmodule TaskManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false

      timestamps()
    end

    create index(:users, [:email])
  end
end
