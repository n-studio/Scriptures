class Admin::ManuscriptsController < Admin::RecordsController
  private

  def record_scope
    Manuscript.all
  end

  def record_path(...)
    admin_manuscript_path(...)
  end

  def record_class
    Manuscript
  end

  def index_columns
    %w[id name abbreviation language date_description]
  end

  def show_columns
    %w[id name abbreviation language corpus_id date_description description facsimile_url created_at updated_at]
  end

  def edit_columns
    %w[name abbreviation language corpus_id date_description description facsimile_url]
  end

  def record_params
    params.require(:manuscript).permit(:name, :abbreviation, :language, :corpus_id, :date_description, :description, :facsimile_url)
  end
end
