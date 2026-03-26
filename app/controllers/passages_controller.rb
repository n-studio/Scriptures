class PassagesController < ApplicationController
  def show
    if params[:corpus_slug]
      @corpus = Corpus.find_by!(slug: params[:corpus_slug])
      @scripture = @corpus.scriptures.find_by!(slug: params[:scripture_slug])
      @division = @scripture.divisions.find_by!(number: params[:division_number])
    else
      # Default: Genesis 1
      @corpus = Corpus.find_by!(slug: "bible")
      @scripture = @corpus.scriptures.find_by!(slug: "genesis")
      @division = @scripture.divisions.find_by!(number: 1)
    end

    @tradition = @corpus.tradition
    @passages = @division.passages.includes(:passage_translations, :translations, :source_documents)
    @translations = @corpus.translations
    @source_documents = @corpus.source_documents

    # Primary and secondary translations for the reading view
    @primary_translation = @translations.find_by(language: "Hebrew") || @translations.first
    @secondary_translation = @translations.find_by(abbreviation: "KJV") || @translations.second
  end
end
