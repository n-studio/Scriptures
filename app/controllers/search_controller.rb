class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @results = if @query.present?
      PassageTranslation.where("text LIKE ?", "%#{@query}%")
                        .includes(passage: { division: { scripture: { corpus: :tradition } } }, translation: {})
                        .limit(50)
    else
      PassageTranslation.none
    end
  end
end
