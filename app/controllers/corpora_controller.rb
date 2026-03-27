class CorporaController < ApplicationController
  def show
    @tradition = Tradition.find_by!(slug: params[:tradition_id])
    @corpus = @tradition.corpora.find_by!(slug: params[:slug])
    @sort = params[:sort]

    @scriptures = @corpus.scriptures.includes(:divisions, :composition_dates)

    if @sort == "date"
      @scriptures = @scriptures.left_joins(:composition_dates)
        .order("composition_dates.earliest_year ASC NULLS LAST, scriptures.position ASC")
        .distinct
    end
  end
end
