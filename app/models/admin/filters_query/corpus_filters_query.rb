class Admin::FiltersQuery::CorpusFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = ilike_query(query, :name, @filter[:name])
    query = ilike_query(query, :slug, @filter[:slug])
    query = range_query(query, :tradition_id, @filter[:tradition_id])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id name slug tradition_id]
  end
end
