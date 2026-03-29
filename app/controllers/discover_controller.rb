class DiscoverController < ApplicationController
  require_authentication only: %i[stats exploration]

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

  def stats
    @passages_read = current_user.reading_progresses.count
    @total_time = current_user.reading_progresses.sum(:time_spent_seconds)
    @words_encountered = current_user.reading_progresses
      .joins(passage: :passage_translations)
      .sum("array_length(string_to_array(passage_translations.text, ' '), 1)")

    @recent_reads = current_user.reading_progresses
      .includes(passage: { division: { scripture: :corpus } })
      .order(read_at: :desc)
      .limit(20)

    @daily_counts = current_user.reading_progresses
      .where("read_at >= ?", 30.days.ago)
      .group("DATE(read_at)")
      .count
      .transform_keys { |k| k.to_date }
  end

  def word_frequency
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

  def exploration
    @corpora = Corpus.includes(scriptures: :divisions).order(:name)

    read_passage_ids = current_user.reading_progresses.pluck(:passage_id).to_set

    @coverage = {}
    @corpora.each do |corpus|
      corpus.scriptures.each do |scripture|
        scripture.divisions.each do |division|
          total = division.passages.size
          next if total == 0
          read = division.passages.count { |p| read_passage_ids.include?(p.id) }
          @coverage[division.id] = { read: read, total: total, pct: (read.to_f / total * 100).round }
        end
      end
    end
  end
end
