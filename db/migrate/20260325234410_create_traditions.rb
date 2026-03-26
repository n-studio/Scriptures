class CreateTraditions < ActiveRecord::Migration[8.1]
  def change
    create_table :traditions do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description

      t.timestamps
    end
    add_index :traditions, :slug, unique: true
  end
end
