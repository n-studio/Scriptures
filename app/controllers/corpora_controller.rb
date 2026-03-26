class CorporaController < ApplicationController
  def show
    @tradition = Tradition.find_by!(slug: params[:tradition_id])
    @corpus = @tradition.corpora.find_by!(slug: params[:slug])
    @scriptures = @corpus.scriptures.includes(:divisions)
  end
end
