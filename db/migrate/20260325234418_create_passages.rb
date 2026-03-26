class CreatePassages < ActiveRecord::Migration[8.1]
  def change
    create_table :passages do |t|
      t.integer :number
      t.integer :position
      t.references :division, null: false, foreign_key: true

      t.timestamps
    end
  end
end
