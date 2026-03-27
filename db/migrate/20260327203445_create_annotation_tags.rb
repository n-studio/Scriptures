class CreateAnnotationTags < ActiveRecord::Migration[8.1]
  def change
    create_table :annotation_tags do |t|
      t.references :annotation, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :annotation_tags, [ :annotation_id, :tag_id ], unique: true
  end
end
