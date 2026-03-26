class PassageTranslation < ApplicationRecord
  belongs_to :passage
  belongs_to :translation

  validates :text, presence: true
  validates :passage_id, uniqueness: { scope: :translation_id }
end
