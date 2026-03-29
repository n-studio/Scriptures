class Admin::FiltersQuery::UserFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = ilike_query(query, :email, @filter[:email])
    query = ilike_query(query, :display_name, @filter[:display_name])
    query = boolean_query(query, :admin, @filter[:admin])
    query = ilike_query(query, :language, @filter[:language])
    query = date_query(query, :created_at, @filter[:created_at])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id email display_name admin language created_at]
  end
end
