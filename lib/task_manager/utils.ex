defmodule TaskManager.Utils do
  def now(), do: DateTime.to_unix(DateTime.utc_now())
end