defmodule SportegicWeb.TaskController do
  use SportegicWeb, :controller

  alias Sportegic.Tasks
  alias Sportegic.Tasks.Task
  alias Sportegic.Users
  alias Sportegic.Notes

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, permissions) do
    with :ok <- Bodyguard.permit(Tasks, "view:task_permissions", "", permissions) do
      tasks_assigned = Tasks.list_tasks_assigned(conn.assigns.user.id, org)
      tasks_created = Tasks.list_tasks_created(conn.assigns.user.id, org)

      render(conn, "index.html",
        tasks_assigned: tasks_assigned,
        tasks_created: tasks_created
      )
    end
  end

  def new(conn, params, org, permissions) do
    with :ok <- Bodyguard.permit(Tasks, "create:task_permissions", "", permissions) do  
      case Map.has_key?(params, "note_id") do
        false ->
          changeset = Tasks.change_task(%Task{})
          render(conn, "new.html", changeset: changeset)
        _     ->
          note = Notes.get_note_only(params["note_id"], org)
          changeset = Tasks.change_task(%Task{})
          render(conn, "new.html", changeset: changeset, note: note)
      end
    end
  end

  def create(conn, %{"task" => task_params} = params, org, permissions) do
    with :ok <- Bodyguard.permit(Tasks, "create:task_permissions", "", permissions),  
      %{id: user_id} <- Users.get_user_by_name(task_params["assignee_name"], org) do
       
      case task_params
            |> Map.put("note_id", params["note_id"])
            |> Map.put("user_id", conn.assigns.user.id)
            |> Map.put("assignee_id", Integer.to_string(user_id))
            |> Tasks.create_task(org) do

        {:ok, task} -> 
          task_params = Map.put_new(task_params, "people", [])
          task
          |> Tasks.create_task_person(task_params["people"], org)
          
          conn
          |> put_flash(:info, "Task created successfully.")
          |> redirect(to: Routes.task_path(conn, :show, task))  
        
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset, assignee_name: task_params["assignee_name"])  
      end
    else
      {:error, :unauthorized} ->
        conn
        |> put_flash(:danger, "You are not authorised to enter this section of the site!")
        |> redirect(to: Routes.dashboard_path(conn, :index))
      {:error, msg} ->
        conn
        |> put_flash(:danger, msg)
        |> redirect(to: Routes.task_path(conn, :new))

    end
  end

  def show(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Tasks, "view:task_permissions", "", permissions) do  
      task = Tasks.get_task!(id, org)
      render(conn, "show.html", task: task)
    end
  end

  def edit(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Tasks, "edit:task_permissions", "", permissions) do  
      task = Tasks.get_task!(id, org)
      changeset = Tasks.change_task(task)
      render(conn, "edit.html", task: task, changeset: changeset, assignee_name: task.assignee.fullname)
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}, org, permissions) do
    with :ok <- Bodyguard.permit(Tasks, "edit:task_permissions", "", permissions) do  
      task = Tasks.get_task!(id, org)
      task_params = Map.put_new(task_params, "people", [])
      
      case Tasks.update_task(task, task_params, org) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Task updated successfully.")
          |> redirect(to: Routes.task_path(conn, :show, task))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", task: task, changeset: changeset)
      end
    end
  end

  def complete(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Tasks, "edit:task_permissions", "", permissions) do  
      task = Tasks.get_task!(id, org)

      task_params = %{}
      |> Map.put("completed", "true")
      |> Map.put("completed_date", DateTime.utc_now())
      |> Map.put("completed_by_id", to_string(conn.assigns.user.id))

      case Tasks.update_task(task, task_params, org) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Task updated successfully.")
          |> redirect(to: Routes.task_path(conn, :show, task))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", task: task, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Tasks, "delete:task_permissions", "", permissions) do  
      task = Tasks.get_task!(id, org)
      {:ok, _task} = Tasks.delete_task(task, org)

      conn
      |> put_flash(:info, "Task deleted successfully.")
      |> redirect(to: Routes.task_path(conn, :index))
    end
  end

end
