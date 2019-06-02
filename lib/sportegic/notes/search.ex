defmodule Sportegic.Notes.Search do
  import Ecto.Query, warn: false
  alias Sportegic.Repo
  
  defmacro search_notes_where(search_term) do
    quote do
      fragment(
        """
        search @@ to_tsquery(?)
        """,
        ^unquote(search_term)
      )
    end
  end

  defmacro search_notes_order_by(search_term) do
    quote do
      fragment(
        """
        ts_rank(search, to_tsquery(?)))
        """,
        ^unquote(search_term)
      )
    end
  end

  def run(search_term, org) do
    # search_term = prefix_search(search_term)
    from(note in "notes_search_view",
      select: note.id,
      where: search_notes_where(prefix_search(search_term)),
      order_by: [ desc: search_notes_order_by(prefix_search(search_term)) ]
    )
    |> Repo.all(prefix: org)
  end

  def prefix_search(term), do: String.replace(term, ~r/\W/u, "") <> ":*"
end
