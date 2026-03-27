class Translation < ApplicationRecord
  EDITION_TYPES = %w[critical devotional original].freeze

  belongs_to :corpus
  has_many :passage_translations, dependent: :destroy

  validates :name, presence: true
  validates :abbreviation, presence: true
  validates :edition_type, inclusion: { in: EDITION_TYPES }, allow_nil: true

  scope :critical, -> { where(edition_type: "critical") }
  scope :devotional, -> { where(edition_type: "devotional") }
  scope :original, -> { where(edition_type: "original") }

  def critical? = edition_type == "critical"
  def devotional? = edition_type == "devotional"
  def original? = edition_type == "original"
end
