class FeaturedPassage < ApplicationRecord
  belongs_to :passage

  validates :title, :context, :active_from, presence: true

  scope :current, -> { where("active_from <= ? AND (active_until IS NULL OR active_until >= ?)", Date.current, Date.current) }

  def self.current_featured
    current.order(active_from: :desc).first
  end
end
