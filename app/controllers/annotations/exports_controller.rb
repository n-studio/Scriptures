module Annotations
  class ExportsController < ApplicationController
    require_authentication

    def show
      annotations = current_user.annotations.includes(passage: { division: { scripture: :corpus } }, tags: [])

      respond_to do |format|
        format.json do
          data = annotations.map { |a| annotation_to_hash(a) }
          send_data data.to_json, filename: "annotations-#{Date.current}.json", type: "application/json"
        end
        format.csv do
          csv = generate_csv(annotations)
          send_data csv, filename: "annotations-#{Date.current}.csv", type: "text/csv"
        end
      end
    end

    private

    def annotation_to_hash(annotation)
      passage = annotation.passage
      scripture = passage.division.scripture
      corpus = scripture.corpus
      {
        corpus: corpus.slug,
        scripture: scripture.slug,
        chapter: passage.division.number,
        verse: passage.number,
        reference: "#{scripture.name} #{passage.division.number}:#{passage.number}",
        body: annotation.body,
        tags: annotation.tags.pluck(:name),
        public: annotation.public?,
        created_at: annotation.created_at.iso8601
      }
    end

    def generate_csv(annotations)
      require "csv"
      CSV.generate do |csv|
        csv << %w[Reference Corpus Scripture Chapter Verse Body Tags Public Created]
        annotations.each do |a|
          passage = a.passage
          scripture = passage.division.scripture
          corpus = scripture.corpus
          csv << [
            "#{scripture.name} #{passage.division.number}:#{passage.number}",
            corpus.slug,
            scripture.slug,
            passage.division.number,
            passage.number,
            a.body,
            a.tags.pluck(:name).join("; "),
            a.public?,
            a.created_at.iso8601
          ]
        end
      end
    end
  end
end
