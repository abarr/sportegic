defmodule Sportegic.TasksTest do
  use Sportegic.DataCase

  alias Sportegic.Tasks

  describe "tasks" do
    alias Sportegic.Tasks.Task

    @valid_attrs %{action: "some action", due_date: ~D[2010-04-17]}
    @update_attrs %{action: "some updated action", due_date: ~D[2011-05-18]}
    @invalid_attrs %{action: nil, due_date: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tasks.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Tasks.create_task(@valid_attrs)
      assert task.action == "some action"
      assert task.due_date == ~D[2010-04-17]
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)
      assert task.action == "some updated action"
      assert task.due_date == ~D[2011-05-18]
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "task_people" do
    alias Sportegic.Tasks.TaskPeople

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def task_people_fixture(attrs \\ %{}) do
      {:ok, task_people} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tasks.create_task_people()

      task_people
    end

    test "list_task_people/0 returns all task_people" do
      task_people = task_people_fixture()
      assert Tasks.list_task_people() == [task_people]
    end

    test "get_task_people!/1 returns the task_people with given id" do
      task_people = task_people_fixture()
      assert Tasks.get_task_people!(task_people.id) == task_people
    end

    test "create_task_people/1 with valid data creates a task_people" do
      assert {:ok, %TaskPeople{} = task_people} = Tasks.create_task_people(@valid_attrs)
    end

    test "create_task_people/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task_people(@invalid_attrs)
    end

    test "update_task_people/2 with valid data updates the task_people" do
      task_people = task_people_fixture()
      assert {:ok, %TaskPeople{} = task_people} = Tasks.update_task_people(task_people, @update_attrs)
    end

    test "update_task_people/2 with invalid data returns error changeset" do
      task_people = task_people_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task_people(task_people, @invalid_attrs)
      assert task_people == Tasks.get_task_people!(task_people.id)
    end

    test "delete_task_people/1 deletes the task_people" do
      task_people = task_people_fixture()
      assert {:ok, %TaskPeople{}} = Tasks.delete_task_people(task_people)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task_people!(task_people.id) end
    end

    test "change_task_people/1 returns a task_people changeset" do
      task_people = task_people_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task_people(task_people)
    end
  end
end
