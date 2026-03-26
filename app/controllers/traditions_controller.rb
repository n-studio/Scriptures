class TraditionsController < ApplicationController
  def index
    @traditions = Tradition.all.includes(:corpora)
  end

  def show
    @tradition = Tradition.find_by!(slug: params[:id])
    @corpora = @tradition.corpora.includes(:scriptures)
  end
end
