class CreateDivisions < ActiveRecord::Migration[8.1]
  def change
    create_table :divisions do |t|
      t.string :name
      t.integer :number
      t.integer :position
      t.references :scripture, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :divisions }

      t.timestamps
    end
  end
end
