defmodule Sportegic.Repo.Migrations.CreateNoteSearchView do
  use Ecto.Migration

  def up do
    execute("""
      CREATE MATERIALIZED VIEW #{prefix()}.notes_search_view AS
        SELECT n.id AS id, (
          setweight(to_tsvector(p.firstname || ' ' || p.lastname  || ' ' || p.preferred_name ), 'A') ||
          setweight(to_tsvector(coalesce(string_agg(t.name, ' '), ' ')), 'B') ||
          setweight(to_tsvector(n.subject), 'C') ||
          setweight(to_tsvector(n.details), 'D')
        ) AS search
      FROM #{prefix()}.notes AS n
      LEFT JOIN #{prefix()}.notes_people as np ON np.note_id = n.id
      LEFT JOIN #{prefix()}.people as p ON p.id = np.person_id
      LEFT JOIN #{prefix()}.note_type as nt ON nt.note_id = n.id
      LEFT JOIN #{prefix()}.types as t ON t.id = nt.type_id
      GROUP BY n.id
    """)

    # to support full-text searches
    create(index("notes_search_view", ["search"], using: :gin))
    # to support substring title matches with ILIKE
    # execute(
    #   "CREATE INDEX notes_search_title_trgm_index ON #{prefix()}.notes_search_view USING gin (subject gin_trgm_ops)"
    # )

    # to support updating CONCURRENTLY
    create(unique_index("notes_search_view", [:id]))

    execute("""
      CREATE OR REPLACE FUNCTION #{prefix()}.refresh_notes_search() RETURNS TRIGGER LANGUAGE plpgsql AS $$
        BEGIN REFRESH MATERIALIZED VIEW CONCURRENTLY #{prefix()}.notes_search_view;
          RETURN NULL;
        END $$;
    """)

    execute("""
      CREATE TRIGGER refresh_notes_search
        AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
        ON #{prefix()}.notes
        FOR EACH STATEMENT
        EXECUTE PROCEDURE #{prefix()}.refresh_notes_search();
    """)

    execute("""
        CREATE TRIGGER refresh_notes_search
        AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
        ON #{prefix()}.note_type
        FOR EACH STATEMENT
        EXECUTE PROCEDURE #{prefix()}.refresh_notes_search();
    """)

    execute("""
        CREATE TRIGGER refresh_notes_search
        AFTER UPDATE OR TRUNCATE ON #{prefix()}.types
        FOR EACH STATEMENT
        EXECUTE PROCEDURE #{prefix()}.refresh_notes_search();
    """)
  end

  def down do
    execute("DROP TRIGGER refresh_notes_search")
    execute("DROP FUNCTION #{prefix()}.refresh_notes_search()")
    execute("DROP INDEX notes_search_view")
    execute("DROP UNIQUE INDEX notes_search_view")
    execute("DROP INDEX notes_search_title_trgm_index")
    execute("DROP MATERIALIZED VIEW #{prefix()}.notes_search_view")
  end
end
