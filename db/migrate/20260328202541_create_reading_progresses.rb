class CreateReadingProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :passage, null: false, foreign_key: true
      t.datetime :read_at, null: false

      t.timestamps
    end

    add_index :reading_progresses, [ :user_id, :passage_id ], unique: true
  end
end
