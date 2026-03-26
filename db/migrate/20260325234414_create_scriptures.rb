class CreateScriptures < ActiveRecord::Migration[8.1]
  def change
    create_table :scriptures do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :position
      t.references :corpus, null: false, foreign_key: { to_table: :corpora }

      t.timestamps
    end
    add_index :scriptures, [ :corpus_id, :slug ], unique: true
  end
end
