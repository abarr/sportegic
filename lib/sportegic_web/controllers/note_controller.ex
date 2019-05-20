defmodule SportegicWeb.NoteController do
  use SportegicWeb, :controller

  alias Sportegic.Notes
  alias Sportegic.Notes.Note

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  # Allows for getting Types by LookupType
  # @type_ref "Note Tags"

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, _permissions) do
    notes = Notes.list_notes(org)
    render(conn, "index.html", notes: notes)
  end

  def new(conn, _params, _org, _permissions) do
    changeset = Notes.change_note(%Note{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"note" => note_params} = params, org, _permissions) do
    note_params = Map.put(note_params, "user_id", conn.assigns.user.id)
    %{"tags" => tags_list} = note_params

    case Notes.create_note(note_params, org) do
      {:ok, note} ->
        case Notes.create_note_types(note, tags_list, org) do
          :ok ->
            conn
            |> put_flash(:info, "Note created successfully.")
            |> redirect(to: Routes.note_path(conn, :show, note))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
    end
  end

  def show(conn, %{"id" => id}, org, _permissions) do
    note = Notes.get_note!(id, org)
    render(conn, "show.html", note: note)
  end

  def edit(conn, %{"id" => id}, org, _permissions) do
    note = Notes.get_note!(id, org)
    changeset = Notes.change_note(note)
    render(conn, "edit.html", note: note, changeset: changeset)
  end

  def update(conn, %{"id" => id, "note" => note_params}, org, _permissions) do
    note = Notes.get_note!(id, org)

    case Notes.update_note(note, note_params, org) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note updated successfully.")
        |> redirect(to: Routes.note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", note: note, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, org) do
    note = Notes.get_note!(id, org)
    {:ok, _note} = Notes.delete_note(note, org)

    conn
    |> put_flash(:info, "Note deleted successfully.")
    |> redirect(to: Routes.note_path(conn, :index))
  end
end
