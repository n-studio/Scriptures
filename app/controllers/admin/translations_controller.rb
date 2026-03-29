class Admin::TranslationsController < Admin::RecordsController
  private

  def record_scope
    Translation.includes(:corpus)
  end

  def record_path(...)
    admin_translation_path(...)
  end

  def record_class
    Translation
  end

  def index_columns
    %w[id name abbreviation language edition_type corpus_id]
  end

  def show_columns
    %w[id name abbreviation language edition_type corpus_id description created_at updated_at]
  end

  def edit_columns
    %w[name abbreviation language edition_type corpus_id description]
  end

  def record_params
    params.require(:translation).permit(:name, :abbreviation, :language, :edition_type, :corpus_id, :description)
  end
end
