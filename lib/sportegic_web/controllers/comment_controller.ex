defmodule SportegicWeb.CommentController do
    use SportegicWeb, :controller
    
    alias Sportegic.Notes
  
    plug SportegicWeb.Plugs.Authenticate
    action_fallback SportegicWeb.FallbackController
  
    def action(conn, _) do
      args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
      apply(__MODULE__, action_name(conn), args)
    end

    def create(conn, %{"comment" => comment_params, "note_id" => note_id }, org, _permissions) do
        with {:ok, _comments} <- Notes.create_comment(note_id, conn.assigns.user.id, comment_params, org) do
            note = Notes.get_note!(note_id, org)
            conn
            |> redirect(to: Routes.note_path(conn, :show, note ))    
        end
    end

    def delete(conn, %{"id" => id, "note_id" => note_id}, org, _permissions) do
        comment = Notes.get_comment!(id, org)
        {:ok, _comment} = Notes.delete_comment(comment, org)
        note = Notes.get_note!(note_id, org)
        conn
        |> put_flash(:danger, "Comment deleted successfully.")
        |> redirect(to: Routes.note_path(conn, :show, note))
    end

end  