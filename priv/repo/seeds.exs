# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaskManager.Repo.insert!(%TaskManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias TaskManager.Repo
alias TaskManager.Users.User
alias TaskManager.Tasks
alias TaskManager.Tasks.Task
alias TaskManager.TimeBlocks
alias TaskManager.TimeBlocks.TimeBlock

import TaskManager.Utils

import Ecto.Query

# Reset stuff
Repo.delete_all(TimeBlock)
Repo.delete_all(Task)
Repo.delete_all(User)

# Insert Users
manager = Repo.insert!(%User{email: "manager@example.com"})
alice   = Repo.insert!(%User{email: "alice@example.com", manager_id: manager.id})
bob     = Repo.insert!(%User{email: "bob@example.com", manager_id: manager.id})

# IO.inspect([manager, alice, bob])

# Insert Tasks
aT1 = Repo.insert!(%Task{title: "First Task Alice", user_id: alice.id})
aT2 = Repo.insert!(%Task{title: "Second Task Alice", user_id: alice.id})

bT1 = Repo.insert!(%Task{title: "First Task Bob", user_id: bob.id})
bT2 = Repo.insert!(%Task{title: "Second Task Bob", user_id: bob.id})

# Insert TimeBlocks
start_time = now() - 200
Repo.insert!(%TimeBlock{start_time: start_time - 200, task_id: aT1.id})
Repo.insert!(%TimeBlock{start_time: start_time, task_id: aT1.id})

print_tbs = fn task ->
  q = from tb in TimeBlock,
                where: tb.task_id == ^aT1.id,
                select: {tb.id, tb.start_time, tb.end_time}

  results = Enum.map(Repo.all(q), fn {id, start, end_t} -> "TB(#{id}): #{start} -> #{end_t}\n" end)
  IO.puts(Enum.join(results))
end

test1 = fn task ->
  :timer.sleep(1000)
  Tasks.complete_time_blocks(task)
  print_tbs.(task)

  :timer.sleep(1000)
  Tasks.start_working(task)
  print_tbs.(task)

  :timer.sleep(1000)
  Tasks.stop_working(task)
  print_tbs.(task)
end

test1.(aT1)

#bT1tbs = [
#  Repo.insert!(%TimeBlock{start_time: start_time, task_id: bT1.id}),
#  Repo.insert!(%TimeBlock{start_time: start_time, task_id: bT1.id})
#]