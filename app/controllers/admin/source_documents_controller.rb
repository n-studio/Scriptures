class Admin::SourceDocumentsController < Admin::RecordsController
  private

  def record_scope
    SourceDocument.all
  end

  def record_path(...)
    admin_source_document_path(...)
  end

  def record_class
    SourceDocument
  end

  def index_columns
    %w[id name abbreviation corpus_id color]
  end

  def show_columns
    %w[id name abbreviation description corpus_id color bibliography_url created_at updated_at]
  end

  def edit_columns
    %w[name abbreviation description corpus_id color bibliography_url]
  end

  def record_params
    params.require(:source_document).permit(:name, :abbreviation, :description, :corpus_id, :color, :bibliography_url)
  end
end
