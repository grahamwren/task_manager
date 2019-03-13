defmodule TaskManagerWeb.AuthenticationHelpers do
  alias TaskManager.Tasks
  alias TaskManager.Users

  # determine if @user is allowed to access @underling:
  # allowed if @user is @underling or @user manages @underling
  def authenticate_user(underling, user) do
    !!underling && !!user && (underling.id === user.id || underling.manager_id === user.id)
  end

  # determine if @user is allowed to access @task:
  # allowed if @user is allowed to access @task's owner's information
  def authenticate_task(task, user) do
    task_owner = task && Users.get_user(task.user_id)
    authenticate_user(task_owner, user)
  end

  # determines if @user is allowed to access @time_block:
  # allowed if @user is allowed to access @time_block's parent task
  def authentication_time_block(time_block, user) do
    task = time_block && Tasks.get_task(time_block.task_id)
    authenticate_task(task, user)
  end
end