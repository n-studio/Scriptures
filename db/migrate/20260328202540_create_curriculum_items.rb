class CreateCurriculumItems < ActiveRecord::Migration[8.1]
  def change
    create_table :curriculum_items do |t|
      t.references :curriculum, null: false, foreign_key: { to_table: :curricula }
      t.references :passage, null: false, foreign_key: true
      t.integer :position, null: false
      t.string :title
      t.text :notes

      t.timestamps
    end

    add_index :curriculum_items, [ :curriculum_id, :passage_id ], unique: true
  end
end
