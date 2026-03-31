require "json"

module Import
  class StrongsLexicon
    def initialize(file:, language:, progress: nil)
      @file = file
      @language = language
      @progress = progress
    end

    def run
      raw = File.read(@file)
      # Extract the JSON object from between the first { and last }
      start = raw.index("{")
      stop = raw.rindex("}")
      json_str = raw[start..stop]
      data = JSON.parse(json_str)

      puts "Importing Strong's #{@language} lexicon — #{data.size} entries"

      total = 0

      @progress&.call(0, data.size)

      data.each_with_index do |(strongs_number, entry), idx|
        LexiconEntry.find_or_create_by!(strongs_number: strongs_number) do |le|
          le.lemma = entry["lemma"] || ""
          le.language = @language
          le.transliteration = entry["xlit"]
          le.definition = [
            entry["strongs_def"],
            entry["derivation"] ? "Derivation: #{entry['derivation']}" : nil
          ].compact.join(" ")
          le.morphology_label = entry["kjv_def"]
        end

        total += 1
        @progress&.call(idx + 1, data.size) if (idx + 1) % 500 == 0
      end
      @progress&.call(data.size, data.size)

      puts "  #{@language}: #{total} lexicon entries imported"
    end
  end
end
