class DiscoverController < ApplicationController
  def index
    @featured = FeaturedPassage.current_featured
    if @featured
      @featured_passage = @featured.passage
      @featured_scripture = @featured_passage.division.scripture
      @featured_corpus = @featured_scripture.corpus
      @featured_translation = @featured_corpus.translations.first
      @featured_text = @featured_passage.text_for(@featured_translation) if @featured_translation
    end
  end
end
