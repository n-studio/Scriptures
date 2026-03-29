class Admin::AnnotationsController < Admin::RecordsController
  private

  def record_scope
    Annotation.includes(:user, :passage)
  end

  def record_path(...)
    admin_annotation_path(...)
  end

  def record_class
    Annotation
  end

  def index_columns
    %w[id user_id passage_id group_id public created_at]
  end

  def show_columns
    %w[id user_id passage_id body group_id public created_at updated_at]
  end

  def edit_columns
    %w[body public]
  end

  def record_params
    params.require(:annotation).permit(:body, :public)
  end
end
