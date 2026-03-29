class Admin::FiltersQuery::TranslationFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = ilike_query(query, :name, @filter[:name])
    query = ilike_query(query, :abbreviation, @filter[:abbreviation])
    query = ilike_query(query, :language, @filter[:language])
    query = ilike_query(query, :edition_type, @filter[:edition_type])
    query = range_query(query, :corpus_id, @filter[:corpus_id])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id name abbreviation language edition_type corpus_id]
  end
end
