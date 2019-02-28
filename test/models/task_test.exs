defmodule TaskManager.TaskTest do
  use TaskManager.ModelCase

  alias TaskManager.Task

  @valid_attrs %{completed: true, description: "some description", time_worked: 42, title: "some title"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end
end
