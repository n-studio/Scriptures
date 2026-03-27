class CreateCollectionPassages < ActiveRecord::Migration[8.1]
  def change
    create_table :collection_passages do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :passage, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :collection_passages, [ :collection_id, :passage_id ], unique: true
  end
end
