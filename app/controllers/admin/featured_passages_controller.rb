class Admin::FeaturedPassagesController < Admin::RecordsController
  private

  def record_scope
    FeaturedPassage.includes(:passage)
  end

  def record_path(...)
    admin_featured_passage_path(...)
  end

  def record_class
    FeaturedPassage
  end

  def index_columns
    %w[id passage_id title active_from active_until]
  end

  def show_columns
    %w[id passage_id title context active_from active_until created_at updated_at]
  end

  def edit_columns
    %w[passage_id title context active_from active_until]
  end

  def record_params
    params.require(:featured_passage).permit(:passage_id, :title, :context, :active_from, :active_until)
  end
end
