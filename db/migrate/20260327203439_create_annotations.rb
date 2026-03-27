class CreateAnnotations < ActiveRecord::Migration[8.1]
  def change
    create_table :annotations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :passage, null: false, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end
    add_index :annotations, [ :user_id, :passage_id ]
  end
end
