class Admin::GroupsController < Admin::RecordsController
  private

  def record_scope
    Group.includes(:owner)
  end

  def record_path(...)
    admin_group_path(...)
  end

  def record_class
    Group
  end

  def index_columns
    %w[id name owner_id public created_at]
  end

  def show_columns
    %w[id name description owner_id public created_at updated_at]
  end

  def edit_columns
    %w[name description owner_id public]
  end

  def record_params
    params.require(:group).permit(:name, :description, :owner_id, :public)
  end
end
