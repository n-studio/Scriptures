class Admin::CommentariesController < Admin::RecordsController
  private

  def record_scope
    Commentary.includes(:passage)
  end

  def record_path(...)
    admin_commentary_path(...)
  end

  def record_class
    Commentary
  end

  def index_columns
    %w[id passage_id author commentary_type created_at]
  end

  def show_columns
    %w[id passage_id author body commentary_type source created_at updated_at]
  end

  def edit_columns
    %w[passage_id author body commentary_type source]
  end

  def record_params
    params.require(:commentary).permit(:passage_id, :author, :body, :commentary_type, :source)
  end
end
