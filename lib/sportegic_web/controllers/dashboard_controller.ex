defmodule SportegicWeb.DashboardController do
  use SportegicWeb, :controller

  alias Sportegic.Tasks
  alias Sportegic.Users

  plug SportegicWeb.Plugs.Authenticate

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org) do
    case Users.get_user(conn.assigns.current_user.id, org) do
      {:ok, nil} ->
        conn
        |> redirect(to: Routes.user_path(conn, :new))
   
      {:ok, user} ->
        my_tasks = Tasks.count_assigned_tasks(user.id, org)
        my_overdue_tasks = Tasks.count_overdue_tasks(user.id, org)
        my_tasks_due_today = Tasks.count_tasks_due_today(user.id, org)
        render(conn, "index.html", 
          user: user,
          my_tasks: my_tasks,
          my_overdue_tasks: my_overdue_tasks,
          my_tasks_due_today: my_tasks_due_today
        )

      resp ->
        IO.inspect(resp, label: "Dashboard Index resp")
    end
  end

end
