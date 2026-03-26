class CreateSourceDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :source_documents do |t|
      t.string :name
      t.string :abbreviation
      t.string :color
      t.text :description
      t.references :corpus, null: false, foreign_key: { to_table: :corpora }

      t.timestamps
    end
  end
end
