class CreateImportRuns < ActiveRecord::Migration[8.1]
  def change
    create_table :import_runs do |t|
      t.string :key, null: false
      t.string :status, null: false, default: "pending"
      t.datetime :started_at
      t.datetime :completed_at
      t.text :error_message
      t.integer :records_count, default: 0

      t.timestamps
    end
    add_index :import_runs, :key
    add_index :import_runs, :status
  end
end
