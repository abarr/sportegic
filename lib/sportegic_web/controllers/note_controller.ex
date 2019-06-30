defmodule SportegicWeb.NoteController do
  use SportegicWeb, :controller

  alias Sportegic.Notes
  alias Sportegic.Notes.{Note, Comment}
  alias HtmlSanitizeEx
  alias Sportegic.People

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, org, permissions) do
    with :ok <- Bodyguard.permit(Notes, "view:note_permissions", "", permissions) do
      notes = Notes.list_notes(org)
      render(conn, "index.html", notes: notes)
    end
  end

  def new(conn, params, org, permissions) do
    with :ok <- Bodyguard.permit(Notes, "create:note_permissions", "", permissions) do
      case Map.has_key?(params, "person_id") do
        false ->
          changeset = Notes.change_note(%Note{})
          render(conn, "new.html", changeset: changeset)

        _ ->
          person = People.get_person_only(params["person_id"], org)
          note = %Note{people: [person], types: []}
          changeset = Notes.change_note(%Note{})
          render(conn, "new.html", changeset: changeset, note: note)
      end
    end
  end

  def create(conn, %{"note" => note_params}, org, permissions) do
    with :ok <- Bodyguard.permit(Notes, "create:note_permissions", "", permissions) do
      # Sanitize user input
      note_params =
        note_params
        |> only_basic_html()
        |> Map.put("user_id", conn.assigns.user.id)

      case Notes.create_note(note_params, org) do
        {:ok, note} ->
          %{"types" => tags_list} = note_params
          Notes.create_note_types(note, tags_list, org)

          case Map.has_key?(note_params, "people") do
            true ->
              %{"people" => people_list} = note_params
              Notes.create_note_people(note, people_list, org)

            _ ->
              nil
          end

          conn
          |> put_flash(:info, "Note created successfully.")
          |> redirect(to: Routes.note_path(conn, :show, note))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  defp only_basic_html(%{"details" => details} = note_params) do
    note_params
    |> Map.put("details", HtmlSanitizeEx.basic_html(details))
  end

  def show(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Notes, "view:note_permissions", "", permissions) do
      note = Notes.get_note!(id, org)
      
      changeset = Notes.change_comment(%Comment{})
      render(conn, "show.html", note: note, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Notes, "edit:note_permissions", "", permissions) do
      note = Notes.get_note!(id, org)
      changeset = Notes.change_note(note)
      render(conn, "edit.html", note: note, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "note" => note_params}, org, permissions) do
    with :ok <- Bodyguard.permit(Notes, "edit:note_permissions", "", permissions) do
      note = Notes.get_note!(id, org)

      case Notes.update_note(note, note_params, org) do
        {:ok, note} ->
          conn
          |> put_flash(:info, "Note created successfully.")
          |> redirect(to: Routes.note_path(conn, :show, note))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", changeset: changeset, note: note)
      end
    end
  end

  def delete(conn, %{"id" => id}, org, permissions) do
    with :ok <- Bodyguard.permit(Notes, "delete:note_permissions", "", permissions) do
      note = Notes.get_note!(id, org)
      {:ok, _note} = Notes.delete_note(note, org)

      conn
      |> put_flash(:info, "Note deleted successfully.")
      |> redirect(to: Routes.note_path(conn, :index))
    end
  end
end
