# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_25_234427) do
  create_table "corpora", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "tradition_id", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_corpora_on_slug", unique: true
    t.index ["tradition_id"], name: "index_corpora_on_tradition_id"
  end

  create_table "divisions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "number"
    t.integer "parent_id"
    t.integer "position"
    t.integer "scripture_id", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_divisions_on_parent_id"
    t.index ["scripture_id"], name: "index_divisions_on_scripture_id"
  end

  create_table "passage_source_documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "passage_id", null: false
    t.integer "source_document_id", null: false
    t.datetime "updated_at", null: false
    t.index ["passage_id"], name: "index_passage_source_documents_on_passage_id"
    t.index ["source_document_id"], name: "index_passage_source_documents_on_source_document_id"
  end

  create_table "passage_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "passage_id", null: false
    t.text "text", null: false
    t.integer "translation_id", null: false
    t.datetime "updated_at", null: false
    t.index ["passage_id", "translation_id"], name: "index_passage_translations_on_passage_id_and_translation_id", unique: true
    t.index ["passage_id"], name: "index_passage_translations_on_passage_id"
    t.index ["translation_id"], name: "index_passage_translations_on_translation_id"
  end

  create_table "passages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "division_id", null: false
    t.integer "number"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_passages_on_division_id"
  end

  create_table "scriptures", force: :cascade do |t|
    t.integer "corpus_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position"
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["corpus_id", "slug"], name: "index_scriptures_on_corpus_id_and_slug", unique: true
    t.index ["corpus_id"], name: "index_scriptures_on_corpus_id"
  end

  create_table "source_documents", force: :cascade do |t|
    t.string "abbreviation"
    t.string "color"
    t.integer "corpus_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["corpus_id"], name: "index_source_documents_on_corpus_id"
  end

  create_table "traditions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_traditions_on_slug", unique: true
  end

  create_table "translations", force: :cascade do |t|
    t.string "abbreviation"
    t.integer "corpus_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "language"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["corpus_id"], name: "index_translations_on_corpus_id"
  end

  add_foreign_key "corpora", "traditions"
  add_foreign_key "divisions", "divisions", column: "parent_id"
  add_foreign_key "divisions", "scriptures"
  add_foreign_key "passage_source_documents", "passages"
  add_foreign_key "passage_source_documents", "source_documents"
  add_foreign_key "passage_translations", "passages"
  add_foreign_key "passage_translations", "translations"
  add_foreign_key "passages", "divisions"
  add_foreign_key "scriptures", "corpora", column: "corpus_id"
  add_foreign_key "source_documents", "corpora", column: "corpus_id"
  add_foreign_key "translations", "corpora", column: "corpus_id"
end
