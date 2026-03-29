class Admin::TraditionsController < Admin::RecordsController
  private

  def record_scope
    Tradition.all
  end

  def record_path(...)
    admin_tradition_path(...)
  end

  def record_class
    Tradition
  end

  def index_columns
    %w[id name slug]
  end

  def show_columns
    %w[id name slug created_at updated_at]
  end

  def edit_columns
    %w[name slug]
  end

  def record_params
    params.require(:tradition).permit(:name, :slug)
  end
end
