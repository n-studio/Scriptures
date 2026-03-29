class Admin::FiltersQuery::FeaturedPassageFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = range_query(query, :passage_id, @filter[:passage_id])
    query = ilike_query(query, :title, @filter[:title])
    query = date_query(query, :active_from, @filter[:active_from])
    query = date_query(query, :active_until, @filter[:active_until])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id passage_id title active_from active_until]
  end
end
