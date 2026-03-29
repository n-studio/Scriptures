module Discover
  class WordFrequenciesController < ApplicationController
    def show
      @corpus = if params[:corpus_slug].present?
        Corpus.find_by!(slug: params[:corpus_slug])
      else
        Corpus.first
      end

      @corpora = Corpus.order(:name)

      @frequencies = OriginalLanguageToken
        .unscope(:order)
        .joins(passage: { division: :scripture })
        .where(scriptures: { corpus_id: @corpus.id })
        .where.not(lemma: [ nil, "" ])
        .group(:lemma)
        .order(Arel.sql("COUNT(*) DESC"))
        .limit(100)
        .pluck(:lemma, Arel.sql("COUNT(*)"))
    end
  end
end
