module Annotations
  class ImportsController < ApplicationController
    require_authentication

    def create
      file = params[:file]
      unless file&.content_type&.in?(%w[application/json])
        redirect_to annotations_path(user_id: current_user), alert: "Please upload a JSON file."
        return
      end

      data = JSON.parse(file.read)
      imported = 0
      skipped = 0

      data.each do |entry|
        passage = find_passage_from_ref(entry)
        next unless passage

        existing = current_user.annotations.find_by(passage: passage, body: entry["body"])
        if existing
          skipped += 1
          next
        end

        annotation = current_user.annotations.new(
          passage: passage,
          body: entry["body"],
          public: entry["public"] || false
        )
        annotation.tag_list = Array(entry["tags"]).join(", ") if entry["tags"].present?
        if annotation.save
          imported += 1
        else
          skipped += 1
        end
      end

      redirect_to annotations_path(user_id: current_user),
        notice: "Imported #{imported} annotation#{'s' unless imported == 1}. Skipped #{skipped} duplicate#{'s' unless skipped == 1}."
    rescue JSON::ParserError
      redirect_to annotations_path(user_id: current_user), alert: "Invalid JSON file."
    end

    private

    def find_passage_from_ref(entry)
      corpus = Corpus.find_by(slug: entry["corpus"])
      return nil unless corpus

      scripture = corpus.scriptures.find_by(slug: entry["scripture"])
      return nil unless scripture

      division = scripture.divisions.find_by(number: entry["chapter"])
      return nil unless division

      division.passages.find_by(number: entry["verse"])
    end
  end
end
