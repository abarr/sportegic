defmodule Sportegic.Tasks do
  @moduledoc """
  The Tasks context.
  """
  use Timex
  alias __MODULE__
  alias Ecto.Changeset
  import Ecto.Query, warn: false
  alias Sportegic.Repo
  alias Sportegic.Tasks.TaskPerson
  alias Sportegic.Tasks.Task
  alias Sportegic.People
  alias Sportegic.Users.User

  defdelegate authorize(action, user, params), to: Sportegic.Users.Authorisation
  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks_assigned(id, org) do
    Task
    |> join(:inner, [t], u in User, on: t.assignee_id == ^id)
    |> where([t], t.completed == false)
    |> distinct(true)
    |> order_by([t, u], asc: t.due_date)
    |> Repo.all(prefix: org)
    |> Repo.preload([:people, :user])
  end

  def count_assigned_tasks(id, org) do
    query =
      from(t in Task,
        join: u in User,
        on: u.id == ^id,
        where: t.completed == false,
        select: {t.id}
      )

    Repo.aggregate(query, :count, :id, prefix: org)
  end

  def count_overdue_tasks(id, org) do
    today = DateTime.utc_now()

    query =
      from(t in Task,
        where: t.assignee_id == ^id,
        where: t.due_date < ^today,
        where: t.completed == false,
        select: {t.id}
      )
    query
    |> Repo.aggregate(:count, :id, prefix: org)
    |> IO.inspect
  end

  def count_tasks_due_today(id, org) do
    today = DateTime.utc_now()

    query =
      from(t in Task,
        join: u in User,
        on: u.id == ^id,
        where: t.due_date == ^today,
        where: t.completed == false,
        select: {t.id}
      )

    Repo.aggregate(query, :count, :id, prefix: org)
  end

  def list_tasks_created(id, org) do
    Task
    |> join(:inner, [t], u in User, on: t.user_id == ^id)
    |> distinct(true)
    |> order_by([t, u], asc: t.due_date)
    |> Repo.all(prefix: org)
    |> Repo.preload([:people, :assignee])
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id, org) do
    Task
    |> Repo.get!(id, prefix: org) 
    |> Repo.preload([:people, :user, :assignee, :completed_by, note: [:types, :people, :user]])
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}, org) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs, org) do
    task
    |> Task.changeset(attrs)
    |> Changeset.put_assoc(:people, Tasks.get_updated_people_tags(attrs["people"], org))
    |> Repo.update(prefix: org)
  end

  def get_updated_people_tags(nil, _org), do: []

  def get_updated_people_tags(updated_people, org) when is_list(updated_people) do
    updated_people
    |> Enum.map(&People.get_person_by_name_dob(&1, org))
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task, org) do
    Repo.delete(task, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def change_task(%Task{} = task, attrs) do
    Task.changeset(task, attrs)
  end

  @doc """
  Returns the list of task_person.

  ## Examples

      iex> list_task_person()
      [%TaskPerson{}, ...]

  """
  def list_task_person(org) do
    Repo.all(TaskPerson, prefix: org)
  end

  @doc """
  Gets a single task_person.

  Raises `Ecto.NoResultsError` if the Task people does not exist.

  ## Examples

      iex> task_person!(123)
      %TaskPerson{}

      iex> task_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_person!(id, org), do: Repo.get!(TaskPerson, id, prefix: org)

  @doc """
  Creates a task_person.

  ## Examples

      iex> create_task_person(%{field: value})
      {:ok, %TAskPerson{}}

      iex> create_task_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_person(task, person_text, org) when is_binary(person_text) do
    IO.puts("ADDING TASK PERSON")
    case People.get_person_by_name_dob(person_text, org) do
      person when is_map(person) ->
        TaskPerson.changeset(%TaskPerson{}, %{
          task_id: task.id,
          person_id: person.id
        })
        |> Repo.insert(prefix: org)
      _ ->
        {:error, "error"}
    end
  end

  def create_task_person(task, people_list, org) when is_list(people_list) do
    case Enum.empty?(people_list) do
      true -> :ok
      _ ->
        Enum.each(people_list, &create_task_person(task, &1, org))
        :ok
    end
  end

  @doc """
  Updates a ttask_person.

  ## Examples

      iex> update_task_person(task_person, %{field: new_value})
      {:ok, %TaskPerson{}}

      iex> update_task_person(task_person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_person(%TaskPerson{} = task_person, attrs, org) do
    task_person
    |> TaskPerson.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a TaskPerson.

  ## Examples

      iex> delete_task_person(task_person)
      {:ok, %TaskPerson{}}

      iex> delete_task_person(task_person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_person(%TaskPerson{} = task_person, org) do
    Repo.delete(task_person, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_person changes.

  ## Examples

      iex> change_task_person(task_person)
      %Ecto.Changeset{source: %TaskPerson{}}

  """
  def change_task_person(%TaskPerson{} = task_person) do
    TaskPerson.changeset(task_person, %{})
  end
end
