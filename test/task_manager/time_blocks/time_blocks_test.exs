defmodule TaskManager.TimeBlocksTest do
  use TaskManager.DataCase

  alias TaskManager.TimeBlocks

  describe "time_blocks" do
    alias TaskManager.TimeBlocks.TimeBlock

    @valid_attrs %{end_time: 42, start_time: 42}
    @update_attrs %{end_time: 43, start_time: 43}
    @invalid_attrs %{end_time: nil, start_time: nil}

    def time_block_fixture(attrs \\ %{}) do
      {:ok, time_block} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TimeBlocks.create_time_block()

      time_block
    end

    test "list_time_blocks/0 returns all time_blocks" do
      time_block = time_block_fixture()
      assert TimeBlocks.list_time_blocks() == [time_block]
    end

    test "get_time_block!/1 returns the time_block with given id" do
      time_block = time_block_fixture()
      assert TimeBlocks.get_time_block!(time_block.id) == time_block
    end

    test "create_time_block/1 with valid data creates a time_block" do
      assert {:ok, %TimeBlock{} = time_block} = TimeBlocks.create_time_block(@valid_attrs)
      assert time_block.end_time == 42
      assert time_block.start_time == 42
    end

    test "create_time_block/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TimeBlocks.create_time_block(@invalid_attrs)
    end

    test "update_time_block/2 with valid data updates the time_block" do
      time_block = time_block_fixture()
      assert {:ok, time_block} = TimeBlocks.update_time_block(time_block, @update_attrs)
      assert %TimeBlock{} = time_block
      assert time_block.end_time == 43
      assert time_block.start_time == 43
    end

    test "update_time_block/2 with invalid data returns error changeset" do
      time_block = time_block_fixture()
      assert {:error, %Ecto.Changeset{}} = TimeBlocks.update_time_block(time_block, @invalid_attrs)
      assert time_block == TimeBlocks.get_time_block!(time_block.id)
    end

    test "delete_time_block/1 deletes the time_block" do
      time_block = time_block_fixture()
      assert {:ok, %TimeBlock{}} = TimeBlocks.delete_time_block(time_block)
      assert_raise Ecto.NoResultsError, fn -> TimeBlocks.get_time_block!(time_block.id) end
    end

    test "change_time_block/1 returns a time_block changeset" do
      time_block = time_block_fixture()
      assert %Ecto.Changeset{} = TimeBlocks.change_time_block(time_block)
    end
  end
end
