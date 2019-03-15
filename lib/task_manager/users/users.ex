defmodule TaskManager.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias TaskManager.Repo

  alias TaskManager.Users.User
  alias TaskManager.Tasks.Task

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(from u in User, order_by: [asc: :email])
    |> Repo.preload(:manager)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:manager)

  def get_user(id), do: Repo.get(User, id) |> Repo.preload(:manager)

  def get_manager(%{manager: %{id: _} = m}), do: m
  def get_manager(%{manager: _, manager_id: id}), do: id && Repo.get(User, id)
  def get_manager(id), do: get_user(id) |> fn u -> u.manager end.()

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def get_tasks(user) do
    tasks_query = Ecto.assoc(user, :tasks)
    tasks = Repo.all(tasks_query)
    Enum.map(tasks, fn t -> %Task{t | user: user} end)
  end

  def get_underlings(user) do
    Repo.all(from u in User, where: u.manager_id == ^user.id)
    |> Enum.map(fn u -> %User{u | manager: user} end)
  end

  def get_extended_tasks(user) do
    # Select all underlings and self, then load all tasks, and insert users
    (from u in User, where: u.manager_id == ^user.id, or_where: u.id == ^user.id)
    |> Repo.all
    |> Repo.preload(:tasks)
    |> Enum.flat_map(fn u ->
         Enum.map u.tasks, fn t ->
           %Task{t | user: u}
         end
       end)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end