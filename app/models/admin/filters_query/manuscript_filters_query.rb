class Admin::FiltersQuery::ManuscriptFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = ilike_query(query, :name, @filter[:name])
    query = ilike_query(query, :abbreviation, @filter[:abbreviation])
    query = ilike_query(query, :date_description, @filter[:date_description])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id name abbreviation date_description]
  end
end
