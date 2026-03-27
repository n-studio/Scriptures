class CreateHighlights < ActiveRecord::Migration[8.1]
  def change
    create_table :highlights do |t|
      t.references :user, null: false, foreign_key: true
      t.references :passage, null: false, foreign_key: true
      t.references :translation, null: false, foreign_key: true
      t.string :color, null: false
      t.integer :start_offset, null: false
      t.integer :end_offset, null: false
      t.string :label

      t.timestamps
    end
  end
end
