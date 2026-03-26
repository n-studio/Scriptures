class CreateCorpora < ActiveRecord::Migration[8.1]
  def change
    create_table :corpora do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.references :tradition, null: false, foreign_key: true

      t.timestamps
    end
    add_index :corpora, :slug, unique: true
  end
end
