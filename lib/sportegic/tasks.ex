defmodule Sportegic.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Sportegic.Repo
  alias Sportegic.Tasks.TaskPeople
  alias Sportegic.Tasks.Task
  alias Sportegic.People

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks(org) do
    Repo.all(Task, prefix: org)
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
  def get_task!(id, org), do: Repo.get!(Task, id, prefix: org)

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
    |> Repo.update(prefix: org)
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

  @doc """
  Returns the list of task_people.

  ## Examples

      iex> list_task_people()
      [%TaskPeople{}, ...]

  """
  def list_task_people(org) do
    Repo.all(TaskPeople, prefix: org)
  end

  @doc """
  Gets a single task_people.

  Raises `Ecto.NoResultsError` if the Task people does not exist.

  ## Examples

      iex> get_task_people!(123)
      %TaskPeople{}

      iex> get_task_people!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_people!(id, org), do: Repo.get!(TaskPeople, id, prefix: org)

  @doc """
  Creates a task_people.

  ## Examples

      iex> create_task_people(%{field: value})
      {:ok, %TaskPeople{}}

      iex> create_task_people(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_person(task, person_text, org) when is_binary(person_text) do
    case People.get_person_by_name_dob(person_text, org) do
      person when is_map(person) ->
        TaskPeople.changeset(%TaskPeople{}, %{
          task_id: task.id,
          people_id: person.id
        })
        |> Repo.insert!(prefix: org)

      _ ->
        {:error, "error"}
    end
  end

  def create_task_people(task, people_list, org) when is_list(people_list) do
    Enum.each(people_list, &create_task_person(task, &1, org))
  end

  @doc """
  Updates a task_people.

  ## Examples

      iex> update_task_people(task_people, %{field: new_value})
      {:ok, %TaskPeople{}}

      iex> update_task_people(task_people, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_people(%TaskPeople{} = task_people, attrs, org) do
    task_people
    |> TaskPeople.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  @doc """
  Deletes a TaskPeople.

  ## Examples

      iex> delete_task_people(task_people)
      {:ok, %TaskPeople{}}

      iex> delete_task_people(task_people)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_people(%TaskPeople{} = task_people, org) do
    Repo.delete(task_people, prefix: org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_people changes.

  ## Examples

      iex> change_task_people(task_people)
      %Ecto.Changeset{source: %TaskPeople{}}

  """
  def change_task_people(%TaskPeople{} = task_people) do
    TaskPeople.changeset(task_people, %{})
  end
end
