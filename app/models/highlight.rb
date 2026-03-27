class Highlight < ApplicationRecord
  COLORS = %w[yellow blue green pink purple orange].freeze

  belongs_to :user
  belongs_to :passage
  belongs_to :translation

  validates :color, presence: true, inclusion: { in: COLORS }
  validates :start_offset, presence: true
  validates :end_offset, presence: true
end
