class Admin::FiltersQuery::AnnotationFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = range_query(query, :user_id, @filter[:user_id])
    query = range_query(query, :passage_id, @filter[:passage_id])
    query = range_query(query, :group_id, @filter[:group_id])
    query = boolean_query(query, :public, @filter[:public])
    query = date_query(query, :created_at, @filter[:created_at])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id user_id passage_id group_id public created_at]
  end
end
