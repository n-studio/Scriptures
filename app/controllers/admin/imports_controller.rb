class Admin::ImportsController < Admin::ApplicationController
  def index
    @sources_dir = Rails.root.join("db/seeds/sources")
    @latest_runs = ImportRun.latest_by_key.index_by(&:key)
    @importers = build_importer_list
  end

  def download
    DownloadSourcesJob.perform_later
    redirect_to admin_imports_path, notice: "Source download started in background."
  end

  def run
    key = params[:key]
    importer = importers_map[key]

    unless importer
      redirect_to admin_imports_path, alert: "Unknown importer: #{key}"
      return
    end

    import_run = ImportRun.create!(key: key)
    RunImportJob.perform_later(key, import_run: import_run)
    redirect_to admin_imports_path, notice: "#{importer[:name]} import started in background."
  end

  def run_all
    import_run = ImportRun.create!(key: "all")
    RunImportJob.perform_later("all", import_run: import_run)
    redirect_to admin_imports_path, notice: "Full import started in background."
  end

  private

  def build_importer_list
    sources = Rails.root.join("db/seeds/sources")
    importers_map.map do |key, config|
      files_present = config[:check].call(sources)
      latest_run = @latest_runs[key]
      config.merge(key: key, files_present: files_present, latest_run: latest_run)
    end
  end

  def importers_map
    @importers_map ||= {
      "bible_kjv" => {
        name: "Bible — KJV",
        description: "King James Version from scrollmapper JSON",
        category: :bible,
        check: ->(s) { s.join("kjv.json").exist? }
      },
      "bible_asv" => {
        name: "Bible — ASV",
        description: "American Standard Version from scrollmapper JSON",
        category: :bible,
        check: ->(s) { s.join("asv.json").exist? }
      },
      "bible_ylt" => {
        name: "Bible — YLT",
        description: "Young's Literal Translation from scrollmapper JSON",
        category: :bible,
        check: ->(s) { s.join("ylt.json").exist? }
      },
      "bible_darby" => {
        name: "Bible — Darby",
        description: "Darby Translation from scrollmapper JSON",
        category: :bible,
        check: ->(s) { s.join("darby.json").exist? }
      },
      "quran_arabic" => {
        name: "Quran — Arabic",
        description: "Simple Arabic text from Tanzil.net",
        category: :quran,
        check: ->(s) { s.join("quran_arabic.txt").exist? }
      },
      "quran_sahih" => {
        name: "Quran — Sahih International",
        description: "English translation from Tanzil.net",
        category: :quran,
        check: ->(s) { s.join("quran_sahih.txt").exist? }
      },
      "quran_yusufali" => {
        name: "Quran — Yusuf Ali",
        description: "English translation from Tanzil.net",
        category: :quran,
        check: ->(s) { s.join("quran_yusufali.txt").exist? }
      },
      "quran_pickthall" => {
        name: "Quran — Pickthall",
        description: "English translation from Tanzil.net",
        category: :quran,
        check: ->(s) { s.join("quran_pickthall.txt").exist? }
      },
      "tafsir" => {
        name: "Tafsir",
        description: "Quranic exegesis (Ibn Kathir, al-Jalalayn, al-Tabari)",
        category: :quran,
        check: ->(s) { s.join("tafsir").exist? }
      },
      "sblgnt" => {
        name: "SBLGNT",
        description: "Greek New Testament from MorphGNT word-level files",
        category: :bible,
        check: ->(s) { s.join("sblgnt").exist? && s.join("sblgnt").children.any? }
      },
      "suttacentral" => {
        name: "Dhammapada",
        description: "Pali Canon text from SuttaCentral bilara-data",
        category: :pali,
        check: ->(s) { s.join("suttacentral/dhp/pali").exist? }
      },
      "hadith" => {
        name: "Hadith",
        description: "17 hadith collections from AhmedBaset/hadith-json",
        category: :islamic,
        check: ->(s) { s.join("hadith").exist? && s.join("hadith").glob("*.json").any? }
      },
      "dead_sea_scrolls" => {
        name: "Dead Sea Scrolls",
        description: "Biblical DSS transcriptions from BiblicalDSS JSON",
        category: :bible,
        check: ->(s) { s.join("biblical_dss.json").exist? }
      },
      "strongs_hebrew" => {
        name: "Strong's — Hebrew",
        description: "Hebrew lexicon from OpenScriptures",
        category: :lexicon,
        check: ->(s) { s.join("strongs_hebrew.js").exist? }
      },
      "strongs_greek" => {
        name: "Strong's — Greek",
        description: "Greek lexicon from OpenScriptures",
        category: :lexicon,
        check: ->(s) { s.join("strongs_greek.js").exist? }
      },
      "classify_translations" => {
        name: "Classify Translations",
        description: "Set edition_type on translations (critical, devotional, original)",
        category: :maintenance,
        check: ->(_s) { true }
      }
    }
  end
end
