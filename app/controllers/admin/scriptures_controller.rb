class Admin::ScripturesController < Admin::RecordsController
  private

  def record_scope
    Scripture.includes(:corpus)
  end

  def record_path(...)
    admin_scripture_path(...)
  end

  def record_class
    Scripture
  end

  def index_columns
    %w[id name slug corpus_id position]
  end

  def show_columns
    %w[id name slug corpus_id position created_at updated_at]
  end

  def edit_columns
    %w[name slug corpus_id position]
  end

  def record_params
    params.require(:scripture).permit(:name, :slug, :corpus_id, :position)
  end
end
