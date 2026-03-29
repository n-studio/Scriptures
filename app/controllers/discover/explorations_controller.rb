module Discover
  class ExplorationsController < ApplicationController
    require_authentication

    def show
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
end
