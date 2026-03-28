class CreateCurricula < ActiveRecord::Migration[8.1]
  def change
    create_table :curricula do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.boolean :public, default: false, null: false
      t.string :curriculum_type

      t.timestamps
    end
  end
end
