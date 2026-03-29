module Curricula
  class ExportsController < ApplicationController
    def show
      @curriculum = Curriculum.find(params[:curriculum_id])

      unless @curriculum.public? || (authenticated? && @curriculum.user == current_user)
        redirect_to root_path, alert: "Curriculum not found."
        return
      end

      @items = @curriculum.curriculum_items.includes(passage: { division: { scripture: :corpus } })

      respond_to do |format|
        format.text do
          text = render_plain_text(@curriculum, @items)
          send_data text, filename: "#{@curriculum.name.parameterize}.txt", type: "text/plain"
        end
      end
    end

    private

    def render_plain_text(curriculum, items)
      lines = []
      lines << curriculum.name
      lines << "=" * curriculum.name.length
      lines << ""
      lines << curriculum.description if curriculum.description.present?
      lines << "" if curriculum.description.present?
      lines << "#{items.size} passages"
      lines << ""

      items.each_with_index do |item, i|
        passage = item.passage
        scripture = passage.division.scripture
        corpus = scripture.corpus
        ref = "#{scripture.name} #{passage.division.number}:#{passage.number}"
        lines << "#{i + 1}. #{ref} (#{corpus.name})"
        lines << "   #{item.title}" if item.title.present?
        lines << "   #{item.notes}" if item.notes.present?
      end

      lines.join("\n")
    end
  end
end
