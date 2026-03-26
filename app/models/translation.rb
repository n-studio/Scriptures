class Translation < ApplicationRecord
  belongs_to :corpus
  has_many :passage_translations, dependent: :destroy

  validates :name, presence: true
  validates :abbreviation, presence: true
end
