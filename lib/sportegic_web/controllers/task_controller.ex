defmodule SportegicWeb.TaskController do
  use SportegicWeb, :controller

  alias Sportegic.Tasks
  alias Sportegic.Tasks.Task

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, _permissions) do
    tasks = Tasks.list_tasks(org)
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params, _org, _permissions) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}, org, _permissions) do
    case Tasks.create_task(task_params, org) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, org, _permissions) do
    task = Tasks.get_task!(id, org)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}, org, _permissions) do
    task = Tasks.get_task!(id, org)
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}, org, _permissions) do
    task = Tasks.get_task!(id, org)

    case Tasks.update_task(task, task_params, org) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, org, _permissions) do
    task = Tasks.get_task!(id, org)
    {:ok, _task} = Tasks.delete_task(task, org)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
