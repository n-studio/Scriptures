# == Schema Information
#
# Table name: import_runs
#
#  id            :bigint           not null, primary key
#  completed_at  :datetime
#  error_message :text
#  key           :string           not null
#  records_count :integer          default(0)
#  started_at    :datetime
#  status        :string           default("pending"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_import_runs_on_key     (key)
#  index_import_runs_on_status  (status)
#
class ImportRun < ApplicationRecord
  STATUSES = %w[pending running completed failed].freeze

  validates :key, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :latest_by_key, -> { where(id: select("MAX(id)").group(:key)) }

  def running?
    status == "running"
  end

  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end

  def duration
    return unless started_at
    (completed_at || Time.current) - started_at
  end
end
