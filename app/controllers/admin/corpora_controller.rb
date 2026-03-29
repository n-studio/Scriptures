class Admin::CorporaController < Admin::RecordsController
  private

  def record_scope
    Corpus.includes(:tradition)
  end

  def record_path(...)
    admin_corpora_path(...)
  end

  def record_class
    Corpus
  end

  def index_columns
    %w[id name slug tradition_id]
  end

  def show_columns
    %w[id name slug tradition_id created_at updated_at]
  end

  def edit_columns
    %w[name slug tradition_id]
  end

  def record_params
    params.require(:corpus).permit(:name, :slug, :tradition_id)
  end
end
