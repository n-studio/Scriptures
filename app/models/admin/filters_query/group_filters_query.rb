class Admin::FiltersQuery::GroupFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = ilike_query(query, :name, @filter[:name])
    query = range_query(query, :owner_id, @filter[:owner_id])
    query = boolean_query(query, :public, @filter[:public])
    query = date_query(query, :created_at, @filter[:created_at])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id name owner_id public created_at]
  end
end
