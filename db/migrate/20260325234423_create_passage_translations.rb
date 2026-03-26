class CreatePassageTranslations < ActiveRecord::Migration[8.1]
  def change
    create_table :passage_translations do |t|
      t.references :passage, null: false, foreign_key: true
      t.references :translation, null: false, foreign_key: true
      t.text :text, null: false

      t.timestamps
    end
    add_index :passage_translations, [ :passage_id, :translation_id ], unique: true
  end
end
