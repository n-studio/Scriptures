# Traditions
jewish = Tradition.find_or_create_by!(slug: "jewish") do |t|
  t.name = "Jewish"
  t.description = "The Jewish scriptural tradition including Torah, Nevi'im, Ketuvim, Mishnah, and Talmud."
end

christian = Tradition.find_or_create_by!(slug: "christian") do |t|
  t.name = "Christian"
  t.description = "The Christian scriptural tradition including Old Testament, New Testament, and Deuterocanon."
end

islamic = Tradition.find_or_create_by!(slug: "islamic") do |t|
  t.name = "Islamic"
  t.description = "The Islamic scriptural tradition including Quran, Hadith, Sira, and Tafsir."
end

Tradition.find_or_create_by!(slug: "ancient") do |t|
  t.name = "Ancient & Historical"
  t.description = "Ancient and historical texts including Egyptian, Mesopotamian, Norse, and Mesoamerican traditions."
end

# Corpus: Bible (shared between Jewish and Christian)
bible = Corpus.find_or_create_by!(slug: "bible") do |c|
  c.name = "Bible"
  c.tradition = jewish
  c.description = "The Hebrew Bible / Old Testament, shared foundational text of Judaism and Christianity."
end

# Corpus: New Testament
nt = Corpus.find_or_create_by!(slug: "new-testament") do |c|
  c.name = "New Testament"
  c.tradition = christian
  c.description = "The Christian New Testament, 27 books composed in Koine Greek."
end

# Corpus: Quran
Corpus.find_or_create_by!(slug: "quran") do |c|
  c.name = "Quran"
  c.tradition = islamic
  c.description = "The central religious text of Islam, believed by Muslims to be a revelation from God."
end

# Source documents for the Bible (Documentary Hypothesis)
p_source = SourceDocument.find_or_create_by!(abbreviation: "P", corpus: bible) do |s|
  s.name = "Priestly Source"
  s.color = "blue"
  s.description = "The Priestly source, one of four sources of the Torah identified by the Documentary Hypothesis. Characterized by concern with ritual, genealogy, and precise chronology."
end

SourceDocument.find_or_create_by!(abbreviation: "J", corpus: bible) do |s|
  s.name = "Yahwist Source"
  s.color = "amber"
  s.description = "The Yahwist source, characterized by use of the divine name YHWH and vivid, anthropomorphic depictions of God."
end

# Scriptures within Bible corpus
genesis = Scripture.find_or_create_by!(slug: "genesis", corpus: bible) do |s|
  s.name = "Genesis"
  s.position = 1
  s.description = "The first book of the Torah/Pentateuch. Contains creation narratives, ancestral stories, and the Joseph cycle."
end

Scripture.find_or_create_by!(slug: "exodus", corpus: bible) do |s|
  s.name = "Exodus"
  s.position = 2
  s.description = "The second book of the Torah. Describes the Israelite exodus from Egypt, the covenant at Sinai, and the construction of the Tabernacle."
end

# Scriptures within NT
Scripture.find_or_create_by!(slug: "matthew", corpus: nt) do |s|
  s.name = "Matthew"
  s.position = 1
  s.description = "The Gospel according to Matthew, likely composed ~85 CE."
end

Scripture.find_or_create_by!(slug: "mark", corpus: nt) do |s|
  s.name = "Mark"
  s.position = 2
  s.description = "The Gospel according to Mark, the earliest canonical Gospel, likely composed ~70 CE."
end

Scripture.find_or_create_by!(slug: "luke", corpus: nt) do |s|
  s.name = "Luke"
  s.position = 3
  s.description = "The Gospel according to Luke, likely composed ~85 CE."
end

Scripture.find_or_create_by!(slug: "john", corpus: nt) do |s|
  s.name = "John"
  s.position = 4
  s.description = "The Gospel according to John, likely composed ~90-100 CE."
end

# Divisions (chapters) for Genesis
gen_ch1 = Division.find_or_create_by!(scripture: genesis, number: 1) do |d|
  d.name = "Chapter 1"
  d.position = 1
end

Division.find_or_create_by!(scripture: genesis, number: 2) do |d|
  d.name = "Chapter 2"
  d.position = 2
end

# Passages for Genesis 1:1-5
gen_passages = (1..5).map do |n|
  Passage.find_or_create_by!(division: gen_ch1, number: n) do |p|
    p.position = n
  end
end

# Translations
wlc = Translation.find_or_create_by!(abbreviation: "WLC", corpus: bible) do |t|
  t.name = "Westminster Leningrad Codex"
  t.language = "Hebrew"
  t.description = "The Masoretic Text as represented in the Westminster Leningrad Codex, the oldest complete manuscript of the Hebrew Bible."
end

kjv = Translation.find_or_create_by!(abbreviation: "KJV", corpus: bible) do |t|
  t.name = "King James Version"
  t.language = "English"
  t.description = "The 1611 Authorized Version, the most influential English translation. Public domain."
end

lxx = Translation.find_or_create_by!(abbreviation: "LXX", corpus: bible) do |t|
  t.name = "Septuagint"
  t.language = "Greek"
  t.description = "The ancient Greek translation of the Hebrew scriptures, produced in Alexandria c. 3rd-2nd century BCE."
end

# Genesis 1:1-5 in Hebrew (WLC / Masoretic Text)
hebrew_texts = [
  "בְּרֵאשִׁית בָּרָא אֱלֹהִים אֵת הַשָּׁמַיִם וְאֵת הָאָרֶץ׃",
  "וְהָאָרֶץ הָיְתָה תֹהוּ וָבֹהוּ וְחֹשֶׁךְ עַל־פְּנֵי תְהוֹם וְרוּחַ אֱלֹהִים מְרַחֶפֶת עַל־פְּנֵי הַמָּיִם׃",
  "וַיֹּאמֶר אֱלֹהִים יְהִי אוֹר וַיְהִי־אוֹר׃",
  "וַיַּרְא אֱלֹהִים אֶת־הָאוֹר כִּי־טוֹב וַיַּבְדֵּל אֱלֹהִים בֵּין הָאוֹר וּבֵין הַחֹשֶׁךְ׃",
  "וַיִּקְרָא אֱלֹהִים ׀ לָאוֹר יוֹם וְלַחֹשֶׁךְ קָרָא לָיְלָה וַיְהִי־עֶרֶב וַיְהִי־בֹקֶר יוֹם אֶחָד׃"
]

# Genesis 1:1-5 in English (KJV)
kjv_texts = [
  "In the beginning God created the heaven and the earth.",
  "And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.",
  "And God said, Let there be light: and there was light.",
  "And God saw the light, that it was good: and God divided the light from the darkness.",
  "And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day."
]

# Genesis 1:1-5 in Greek (Septuagint)
lxx_texts = [
  "ἐν ἀρχῇ ἐποίησεν ὁ θεὸς τὸν οὐρανὸν καὶ τὴν γῆν.",
  "ἡ δὲ γῆ ἦν ἀόρατος καὶ ἀκατασκεύαστος, καὶ σκότος ἐπάνω τῆς ἀβύσσου, καὶ πνεῦμα θεοῦ ἐπεφέρετο ἐπάνω τοῦ ὕδατος.",
  "καὶ εἶπεν ὁ θεός Γενηθήτω φῶς. καὶ ἐγένετο φῶς.",
  "καὶ εἶδεν ὁ θεὸς τὸ φῶς ὅτι καλόν. καὶ διεχώρισεν ὁ θεὸς ἀνὰ μέσον τοῦ φωτὸς καὶ ἀνὰ μέσον τοῦ σκότους.",
  "καὶ ἐκάλεσεν ὁ θεὸς τὸ φῶς ἡμέραν καὶ τὸ σκότος ἐκάλεσεν νύκτα. καὶ ἐγένετο ἑσπέρα καὶ ἐγένετο πρωί, ἡμέρα μία."
]

gen_passages.each_with_index do |passage, i|
  PassageTranslation.find_or_create_by!(passage: passage, translation: wlc) { |pt| pt.text = hebrew_texts[i] }
  PassageTranslation.find_or_create_by!(passage: passage, translation: kjv) { |pt| pt.text = kjv_texts[i] }
  PassageTranslation.find_or_create_by!(passage: passage, translation: lxx) { |pt| pt.text = lxx_texts[i] }

  # All Genesis 1:1-5 attributed to Priestly source
  PassageSourceDocument.find_or_create_by!(passage: passage, source_document: p_source)
end

puts "Seeded #{Tradition.count} traditions, #{Corpus.count} corpora, #{Scripture.count} scriptures, #{Division.count} divisions, #{Passage.count} passages, #{Translation.count} translations, #{PassageTranslation.count} passage translations, #{SourceDocument.count} source documents."
