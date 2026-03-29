class Admin::FiltersQuery::CommentaryFiltersQuery < Admin::FiltersQuery::Base
  def all
    query = @relation
    query = range_query(query, :id, @filter[:id])
    query = range_query(query, :passage_id, @filter[:passage_id])
    query = ilike_query(query, :author, @filter[:author])
    query = ilike_query(query, :commentary_type, @filter[:commentary_type])
    query = date_query(query, :created_at, @filter[:created_at])
    query = query.reorder(@order) if @order.present?
    query
  end

  private

  def permitted_filter_params
    %i[id passage_id author commentary_type created_at]
  end
end
