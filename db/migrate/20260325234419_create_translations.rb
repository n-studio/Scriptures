class CreateTranslations < ActiveRecord::Migration[8.1]
  def change
    create_table :translations do |t|
      t.string :name
      t.string :abbreviation
      t.string :language
      t.text :description
      t.references :corpus, null: false, foreign_key: { to_table: :corpora }

      t.timestamps
    end
  end
end
