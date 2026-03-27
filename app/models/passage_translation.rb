class PassageTranslation < ApplicationRecord
  belongs_to :passage
  belongs_to :translation
  has_many :ratings, dependent: :destroy

  validates :text, presence: true
  validates :passage_id, uniqueness: { scope: :translation_id }
end
