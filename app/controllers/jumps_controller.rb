class JumpsController < ApplicationController
  def show
    ref = params[:ref].to_s.strip
    passage = resolve_reference(ref)

    if passage
      division = passage.division
      scripture = division.scripture
      corpus = scripture.corpus
      redirect_to reading_path(corpus_slug: corpus.slug, scripture_slug: scripture.slug, division_number: division.number)
    else
      redirect_back fallback_location: root_path, alert: "Could not find \"#{ref}\"."
    end
  end

  private

  def resolve_reference(ref)
    match = ref.match(/\A(.+?)\s+(\d+):(\d+)\z/)
    return nil unless match

    book_query, chapter, verse = match[1], match[2].to_i, match[3].to_i

    scripture = Scripture.where("name LIKE ? OR slug LIKE ?", "#{book_query}%", "#{book_query.downcase}%").first
    return nil unless scripture

    division = scripture.divisions.find_by(number: chapter)
    return nil unless division

    division.passages.find_by(number: verse)
  end
end
