class AddSearchIndexToPassageTranslations < ActiveRecord::Migration[8.1]
  def up
    add_column :passage_translations, :search_vector, :tsvector

    execute <<~SQL
      CREATE INDEX index_passage_translations_on_search_vector
      ON passage_translations USING gin(search_vector);
    SQL

    execute <<~SQL
      CREATE OR REPLACE FUNCTION passage_translations_search_vector_update() RETURNS trigger AS $$
      BEGIN
        NEW.search_vector := to_tsvector('simple', COALESCE(NEW.text, ''));
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    execute <<~SQL
      CREATE TRIGGER passage_translations_search_vector_trigger
      BEFORE INSERT OR UPDATE OF text ON passage_translations
      FOR EACH ROW EXECUTE FUNCTION passage_translations_search_vector_update();
    SQL

    # Backfill existing rows
    execute <<~SQL
      UPDATE passage_translations SET search_vector = to_tsvector('simple', COALESCE(text, ''));
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS passage_translations_search_vector_trigger ON passage_translations;"
    execute "DROP FUNCTION IF EXISTS passage_translations_search_vector_update();"
    remove_index :passage_translations, name: :index_passage_translations_on_search_vector
    remove_column :passage_translations, :search_vector
  end
end
