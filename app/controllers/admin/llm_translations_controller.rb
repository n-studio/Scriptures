class Admin::LlmTranslationsController < Admin::ApplicationController
  def index
    if params[:scripture_id].present?
      @scripture = Scripture.find(params[:scripture_id])
      @corpus = @scripture.corpus
      @style = valid_style(params[:style])
      @divisions = @scripture.divisions.where(parent_id: nil).order(:position)
      @completion = compute_completion(@scripture, @style)
    elsif params[:corpus_id].present?
      @corpus = Corpus.find(params[:corpus_id])
      @scriptures = @corpus.scriptures.order(:position)
    else
      @corpora = Corpus.order(:name)
    end
  end

  def show
    @division = Division.find(params[:id])
    @scripture = @division.scripture
    @corpus = @scripture.corpus
    @style = valid_style(params[:style])
    @style_config = LlmTranslationJob::STYLES[@style]
    @provider = valid_provider(params[:provider])

    @passages = @division.passages.order(:position)

    # Find original language text (or first available translation as fallback)
    @source_translation = @corpus.translations.find_by(edition_type: "original") ||
                          @corpus.translations.first
    @originals = load_translations(@passages, @source_translation)

    # Find LLM translation for this style
    abbr = "LLM-#{@style_config[:abbreviation_suffix]}"
    @llm_translation = Translation.find_by(abbreviation: abbr, corpus: @corpus)
    @translations = load_translations(@passages, @llm_translation)
  end

  def translate
    style = valid_style(params[:style])
    provider = valid_provider(params[:provider])
    division = Division.find(params[:division_id])

    if params[:passage_id].present?
      LlmTranslationJob.perform_later(passage_id: params[:passage_id].to_i, style: style, provider: provider)
      redirect_to admin_llm_translation_path(division, style: style, provider: provider),
        notice: "Translation enqueued (#{LlmTranslationJob::PROVIDERS[provider][:name]})."
    else
      count = 0
      division.passages.find_each do |passage|
        LlmTranslationJob.perform_later(passage_id: passage.id, style: style, provider: provider)
        count += 1
      end
      redirect_to admin_llm_translation_path(division, style: style, provider: provider),
        notice: "#{count} translations enqueued (#{LlmTranslationJob::PROVIDERS[provider][:name]})."
    end
  end

  def save_passage
    passage = Passage.find(params[:passage_id])
    style = valid_style(params[:style])
    style_config = LlmTranslationJob::STYLES[style]
    corpus = passage.scripture.corpus

    abbr = "LLM-#{style_config[:abbreviation_suffix]}"
    translation = Translation.find_or_create_by!(abbreviation: abbr, corpus: corpus) do |t|
      t.name = "AI #{style_config[:name_suffix]}"
      t.language = "English"
      t.edition_type = "critical"
    end

    pt = PassageTranslation.find_or_initialize_by(passage: passage, translation: translation)
    pt.text = params[:text]
    pt.save!

    redirect_to admin_llm_translation_path(passage.division, style: style),
      notice: "Passage #{passage.number} saved."
  end

  private

  def valid_style(style)
    LlmTranslationJob::STYLES.key?(style) ? style : "word_for_word"
  end

  def valid_provider(provider)
    LlmTranslationJob::PROVIDERS.key?(provider) ? provider : LlmTranslationJob::DEFAULT_PROVIDER
  end

  def load_translations(passages, translation)
    return {} unless translation

    PassageTranslation.where(passage: passages, translation: translation)
      .pluck(:passage_id, :text).to_h
  end

  def compute_completion(scripture, style)
    style_config = LlmTranslationJob::STYLES[style]
    abbr = "LLM-#{style_config[:abbreviation_suffix]}"
    translation = Translation.find_by(abbreviation: abbr, corpus: scripture.corpus)

    total = Passage.unscoped.where(division: scripture.divisions).group(:division_id).count

    translated = {}
    if translation
      translated = PassageTranslation
        .where(translation: translation)
        .joins(:passage)
        .where(passages: { division_id: scripture.division_ids })
        .group("passages.division_id")
        .count
    end

    { total: total, translated: translated }
  end
end
