class Admin::FiltersQuery::LexiconEntryFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = ilike_query(query, :lemma, @filter[:lemma])
    query = ilike_query(query, :language, @filter[:language])
    query = ilike_query(query, :transliteration, @filter[:transliteration])
    query = ilike_query(query, :definition, @filter[:definition])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id lemma language transliteration definition]
  end
end
