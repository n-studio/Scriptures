class Admin::LexiconEntriesController < Admin::RecordsController
  private

  def record_scope
    LexiconEntry.all
  end

  def record_path(...)
    admin_lexicon_entry_path(...)
  end

  def record_class
    LexiconEntry
  end

  def index_columns
    %w[id lemma language transliteration definition]
  end

  def show_columns
    %w[id lemma language transliteration definition morphology_label strongs_number created_at]
  end

  def edit_columns
    %w[lemma language transliteration definition morphology_label strongs_number]
  end

  def record_params
    params.require(:lexicon_entry).permit(:lemma, :language, :transliteration, :definition, :morphology_label, :strongs_number)
  end
end
