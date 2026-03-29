class Admin::FiltersQuery::ScriptureFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = ilike_query(query, :name, @filter[:name])
    query = ilike_query(query, :slug, @filter[:slug])
    query = range_query(query, :corpus_id, @filter[:corpus_id])
    query = range_query(query, :position, @filter[:position])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id name slug corpus_id position]
  end
end
