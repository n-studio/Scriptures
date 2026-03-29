class AddTimeSpentToReadingProgresses < ActiveRecord::Migration[8.1]
  def change
    add_column :reading_progresses, :time_spent_seconds, :integer, default: 0, null: false
  end
end
