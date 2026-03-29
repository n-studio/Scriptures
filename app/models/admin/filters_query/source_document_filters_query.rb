class Admin::FiltersQuery::SourceDocumentFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = ilike_query(query, :name, @filter[:name])
    query = ilike_query(query, :abbreviation, @filter[:abbreviation])
    query = range_query(query, :corpus_id, @filter[:corpus_id])
    query = ilike_query(query, :color, @filter[:color])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id name abbreviation corpus_id color]
  end
end
