class Admin::ImportsController < Admin::ApplicationController
  def index
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

  def cancel
    import_run = ImportRun.find(params[:id])
    if import_run.running?
      import_run.cancel!
      redirect_to admin_imports_path, notice: "#{import_run.key.titleize} import cancelled."
    else
      redirect_to admin_imports_path, alert: "Import is not running."
    end
  end

  private

  def build_importer_list
    importers_map.map do |key, config|
      latest_run = @latest_runs[key]
      config.merge(key: key, latest_run: latest_run)
    end
  end

  def importers_map
    @importers_map ||= {
      "bible_kjv" => {
        name: "Bible — KJV",
        description: "King James Version from scrollmapper JSON",
        category: :bible
      },
      "bible_asv" => {
        name: "Bible — ASV",
        description: "American Standard Version from scrollmapper JSON",
        category: :bible
      },
      "bible_ylt" => {
        name: "Bible — YLT",
        description: "Young's Literal Translation from scrollmapper JSON",
        category: :bible
      },
      "bible_darby" => {
        name: "Bible — Darby",
        description: "Darby Translation from scrollmapper JSON",
        category: :bible
      },
      "quran_arabic" => {
        name: "Quran — Arabic",
        description: "Simple Arabic text from Tanzil.net",
        category: :quran
      },
      "quran_sahih" => {
        name: "Quran — Sahih International",
        description: "English translation from Tanzil.net",
        category: :quran
      },
      "quran_yusufali" => {
        name: "Quran — Yusuf Ali",
        description: "English translation from Tanzil.net",
        category: :quran
      },
      "quran_pickthall" => {
        name: "Quran — Pickthall",
        description: "English translation from Tanzil.net",
        category: :quran
      },
      "tafsir" => {
        name: "Tafsir",
        description: "Quranic exegesis (Ibn Kathir, al-Jalalayn, al-Tabari)",
        category: :quran
      },
      "sblgnt" => {
        name: "SBLGNT",
        description: "Greek New Testament from MorphGNT word-level files",
        category: :bible
      },
      "suttacentral" => {
        name: "Dhammapada",
        description: "Pali Canon text from SuttaCentral bilara-data",
        category: :pali
      },
      "hadith" => {
        name: "Hadith",
        description: "17 hadith collections from AhmedBaset/hadith-json",
        category: :quran
      },
      "sira" => {
        name: "Sira",
        description: "Sirat Rasul Allah — prophetic biography from Internet Archive",
        category: :quran
      },
      "dead_sea_scrolls" => {
        name: "Dead Sea Scrolls",
        description: "Biblical DSS transcriptions from BiblicalDSS JSON",
        category: :bible
      },
      "strongs_hebrew" => {
        name: "Strong's — Hebrew",
        description: "Hebrew lexicon from OpenScriptures",
        category: :lexicon
      },
      "strongs_greek" => {
        name: "Strong's — Greek",
        description: "Greek lexicon from OpenScriptures",
        category: :lexicon
      },
      "classify_translations" => {
        name: "Classify Translations",
        description: "Set edition_type on translations (critical, devotional, original)",
        category: :maintenance
      }
    }
  end
end
