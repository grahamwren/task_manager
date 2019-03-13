defmodule TaskManager.Repo.Migrations.CreateTimeBlocks do
  use Ecto.Migration

  def change do
    create table(:time_blocks) do
      add :start_time, :bigint
      add :end_time, :bigint
      add :task_id, references(:tasks, on_delete: :delete_all)

      timestamps()
    end

    alter table(:tasks) do
      remove :time_worked
    end
  end
end
