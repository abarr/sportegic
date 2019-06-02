defmodule SportegicWeb.TaskController do
  use SportegicWeb, :controller

  alias Ecto.Changeset
  alias Sportegic.Tasks
  alias Sportegic.Tasks.Task
  alias Sportegic.Users

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, _permissions) do
    tasks_assigned = Tasks.list_tasks_assigned(conn.assigns.user.id, org)
    tasks_created = Tasks.list_tasks_created(conn.assigns.user.id, org)

    render(conn, "index.html",
      tasks_assigned: tasks_assigned,
      tasks_created: tasks_created
    )
  end

  def new(conn, _params, _org, _permissions) do
    changeset = Changeset.change(%Task{}, %{note_id: conn.query_params["note"]})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}, org, _permissions) do
    IO.inspect(task_params, label: "TASK PARAMS")
    %{id: user_id} = Users.get_user_by_name(task_params["user"], org)

    task_params =
      task_params
      |> Map.put("note_id", task_params["note_id"])
      |> Map.put("user_id", conn.assigns.user.id)
      |> Map.put("assignee_id", user_id)
      |> IO.inspect()

    case Tasks.create_task(task_params, org) do
      {:ok, task} ->
        case Map.has_key?(task_params, "people") do
          true ->
            %{"people" => people_list} = task_params
            Tasks.create_task_person(task, people_list, org)

          _ ->
            nil
        end

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
