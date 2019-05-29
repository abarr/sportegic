defmodule SportegicWeb.DashboardController do
  use SportegicWeb, :controller

  alias Sportegic.Tasks

  plug SportegicWeb.Plugs.Authenticate

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org) do
    my_tasks = Tasks.count_assigned_tasks(conn.assigns.user.id, org)
    my_overdue_tasks = Tasks.count_overdue_tasks(conn.assigns.user.id, org)
    my_tasks_due_today = Tasks.count_tasks_due_today(conn.assigns.user.id, org)

    render(conn, "index.html",
      my_tasks: my_tasks,
      my_overdue_tasks: my_overdue_tasks,
      my_tasks_due_today: my_tasks_due_today
    )
  end
end
