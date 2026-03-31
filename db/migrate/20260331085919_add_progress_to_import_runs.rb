class AddProgressToImportRuns < ActiveRecord::Migration[8.1]
  def change
    add_column :import_runs, :total_count, :integer, default: 0
    add_column :import_runs, :processed_count, :integer, default: 0
  end
end
