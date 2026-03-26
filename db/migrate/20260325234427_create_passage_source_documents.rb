class CreatePassageSourceDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :passage_source_documents do |t|
      t.references :passage, null: false, foreign_key: true
      t.references :source_document, null: false, foreign_key: true

      t.timestamps
    end
  end
end
