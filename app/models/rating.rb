class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :passage_translation

  validates :score, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :passage_translation_id }
end
