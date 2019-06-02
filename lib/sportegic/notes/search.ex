defmodule Sportegic.Notes.Search do
  import Ecto.Query, warn: false
  alias Sportegic.Repo
  alias Sportegic.Notes.Note

  defmacro search_notes_view(search_term) do
    quote do
      fragment(
        """
        search @@ to_tsquery(?)
        """,
        ^unquote(search_term)
      )
    end
  end

  def find_notes(search_term, org) do
    search_term = prefix_search(search_term)

    from(note in "notes_search_view",
      select: note.id,
      where: search_notes_view(search_term)
    )
    |> Repo.all(prefix: org)
  end

  def prefix_search(term), do: String.replace(term, ~r/\W/u, "") <> ":*"
end
