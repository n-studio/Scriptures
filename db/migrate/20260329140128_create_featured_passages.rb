class CreateFeaturedPassages < ActiveRecord::Migration[8.1]
  def change
    create_table :featured_passages do |t|
      t.references :passage, null: false, foreign_key: true
      t.string :title, null: false
      t.text :context, null: false
      t.date :active_from, null: false
      t.date :active_until

      t.timestamps
    end

    add_index :featured_passages, :active_from
  end
end
